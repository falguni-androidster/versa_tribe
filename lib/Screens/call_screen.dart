import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:sip_ua/sip_ua.dart';
import '../Providers/calling_providers.dart';
import '../Utils/action_button.dart';
import '../Utils/custom_colors.dart';
import '../Utils/image_path.dart';
import '../Utils/notification_service.dart';

class CallScreenWidget extends StatefulWidget {
  final SIPUAHelper? _helper;
  final Call? _call;
  const CallScreenWidget(this._helper, this._call, {super.key});
  @override
  State<CallScreenWidget> createState() => _MyCallScreenWidget();
}

class _MyCallScreenWidget extends State<CallScreenWidget>
  implements SipUaHelperListener {
  RTCVideoRenderer? _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer? _remoteRenderer = RTCVideoRenderer();
  double? _localVideoHeight;
  double? _localVideoWidth;
  EdgeInsetsGeometry? _localVideoMargin;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  bool _showNumPad = false;
  String _timeLabel = '00:00';
  bool _audioMuted = false;
  bool _videoMuted = false;
  bool _speakerOn = false;
  bool _hold = false;
  bool _mirror = true;
  CallStateEnum _state = CallStateEnum.NONE;

  dynamic callProvider;
  late String _transferTarget;
  Timer? _timer;

  SIPUAHelper? get helper => widget._helper;

  bool get voiceOnly => (_localStream == null || _localStream!.getVideoTracks().isEmpty) && (_remoteStream == null || _remoteStream!.getVideoTracks().isEmpty);

  String? get remoteIdentity => call!.remote_display_name;
  String get direction => call!.direction;
  Call? get call => widget._call;

  @override
  initState() {
    super.initState();
    _initRenderers();
    helper!.addSipUaHelperListener(this);
  }
  @override
  deactivate() {
    super.deactivate();
    helper!.removeSipUaHelperListener(this);
    _disposeRenderers();
  }
  void _initRenderers() async {
    if (_localRenderer != null) {
      await _localRenderer!.initialize();
    }
    if (_remoteRenderer != null) {
      await _remoteRenderer!.initialize();
    }
  }
  void _disposeRenderers() {
    if (_localRenderer != null) {
      _localRenderer!.dispose();
      _localRenderer = null;
    }
    if (_remoteRenderer != null) {
      _remoteRenderer!.dispose();
      _remoteRenderer = null;
    }
  }

  void _startTimer() {
    callProvider = Provider.of<CallTimerProvider>(context,listen:false);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      Duration duration = Duration(seconds: timer.tick);
      if (mounted) {
        //callProvider.setCallTimer([duration.inMinutes, duration.inSeconds].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':'));
        setState(() {
          _timeLabel = [duration.inMinutes, duration.inSeconds].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void callStateChanged(Call call, CallState callState) {

    if (callState.state == CallStateEnum.HOLD ||
        callState.state == CallStateEnum.UNHOLD) {
      _hold = callState.state == CallStateEnum.HOLD;
      setState(() {});
      return;
    }

    if (callState.state == CallStateEnum.MUTED) {
      if (callState.audio!) _audioMuted = true;
      if (callState.video!) _videoMuted = true;
      setState(() {});
      return;
    }

    if (callState.state == CallStateEnum.UNMUTED) {
      if (callState.audio!) _audioMuted = false;
      if (callState.video!) _videoMuted = false;
      setState(() {});
      return;
    }

    if (callState.state != CallStateEnum.STREAM) {
      _state = callState.state;
    }

    switch (callState.state) {
      case CallStateEnum.STREAM:
        _handelStreams(callState);
        break;
      case CallStateEnum.ENDED:
      case CallStateEnum.FAILED:
      _backToDialPad();
        FlutterRingtonePlayer().stop();
        break;
      case CallStateEnum.UNMUTED:
      case CallStateEnum.MUTED:
      case CallStateEnum.CONNECTING:
      case CallStateEnum.PROGRESS:
      case CallStateEnum.ACCEPTED:
      case CallStateEnum.CONFIRMED:
      case CallStateEnum.HOLD:
      case CallStateEnum.UNHOLD:
      case CallStateEnum.NONE:
      case CallStateEnum.CALL_INITIATION:
      FlutterRingtonePlayer().stop();//When Third Party Cut the call..
      case CallStateEnum.REFER:
        break;
    }
  }

  @override
  void transportStateChanged(TransportState state) {}

  @override
  void registrationStateChanged(RegistrationState state) {}

  void _cleanUp() {
    if (_localStream == null) return;
    _localStream?.getTracks().forEach((track) {
      track.stop();
    });
    _localStream!.dispose();
    _localStream = null;
  }

  void _backToDialPad() {
    _timer?.cancel();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
    _cleanUp();
  }

  void _handelStreams(CallState event) async {
    MediaStream? stream = event.stream;
    if (event.originator == 'local') {
      if (_localRenderer != null) {
        _localRenderer!.srcObject = stream;
      }
      if (!kIsWeb && !WebRTC.platformIsDesktop) {
        event.stream?.getAudioTracks().first.enableSpeakerphone(false);
      }
      _localStream = stream;
    }
    if (event.originator == 'remote') {
      if (_remoteRenderer != null) {
        _remoteRenderer!.srcObject = stream;
      }
      _remoteStream = stream;
    }

    // setState(() {
    //   _resizeLocalVideo();
    // });
  }

  void _resizeLocalVideo() {
    _localVideoMargin = _remoteStream != null
        ? const EdgeInsets.only(top: 15, right: 15)
        : const EdgeInsets.all(0);
    _localVideoWidth = _remoteStream != null
        ? MediaQuery.of(context).size.width / 4
        : MediaQuery.of(context).size.width;
    _localVideoHeight = _remoteStream != null
        ? MediaQuery.of(context).size.height / 4
        : MediaQuery.of(context).size.height;
  }

  void _handleHangup() {
    FlutterRingtonePlayer().stop();
    call!.hangup({'status_code--------->': 603});
    _timer?.cancel();
  }
  Future<void> _handleAccept() async {
    _startTimer();
    bool remoteHasVideo = call!.remote_has_video;
    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': remoteHasVideo
    };
    MediaStream mediaStream;

    if (kIsWeb && remoteHasVideo) {
      mediaStream = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
      mediaConstraints['video'] = false;
      MediaStream userStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      mediaStream.addTrack(userStream.getAudioTracks()[0], addToNative: true);
    } else
    {
      mediaConstraints['video'] = remoteHasVideo;
      mediaStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    }

    call!.answer(helper!.buildCallOptions(!remoteHasVideo), mediaStream: mediaStream);
  }

  void _switchCamera() {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
      setState(() {
        _mirror = !_mirror;
      });
    }
  }
  void _muteAudio() {
    if (_audioMuted==true) {
      call!.unmute(true, false);
    } else {
      call!.mute(true, false);
    }
  }
  void _muteVideo() {
    if (_videoMuted) {
      call!.unmute(false, true);
    } else {
      call!.mute(false, true);
    }
  }
  void _handleHold() {
    if (_hold) {
      call!.unhold();
    } else {
      call!.hold();
    }
  }

  // void _handleTransfer() {
  //   showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Enter target to transfer.'),
  //         content: TextField(
  //           onChanged: (String text) {
  //             setState(() {
  //               _transferTarget = text;
  //             });
  //           },
  //           decoration: const InputDecoration(
  //             hintText: 'URI or Username',
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Ok'),
  //             onPressed: () {
  //               call!.refer(_transferTarget);
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _handleKeyPad() {
  //   setState(() {
  //     _showNumPad = !_showNumPad;
  //   });
  // }

  void _handleDtmf(String tone) {
    if (kDebugMode) {
      print('Dtmf tone => $tone');
    }
    call!.sendDTMF(tone);
  }

  void _toggleSpeaker() {
    if (_localStream != null) {
      _speakerOn = !_speakerOn;
      if (!kIsWeb) {
        _localStream!.getAudioTracks()[0].enableSpeakerphone(_speakerOn);
      }
    }
  }

  List<Widget> _buildNumPad() {
    final labels = [
      [
        {'1': ''},
        {'2': 'abc'},
        {'3': 'def'}
      ],
      [
        {'4': 'ghi'},
        {'5': 'jkl'},
        {'6': 'mno'}
      ],
      [
        {'7': 'pqrs'},
        {'8': 'tuv'},
        {'9': 'wxyz'}
      ],
      [
        {'*': ''},
        {'0': '+'},
        {'#': ''}
      ],
    ];

    return labels.map((row) => Padding(
            padding: const EdgeInsets.all(3),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row.map((label) => ActionButton(
                          title: label.keys.first,
                          subTitle: label.values.first,
                          onPressed: () => _handleDtmf(label.keys.first),
                          number: true,
                        ))
                    .toList()))).toList();
  }

  Widget _buildActionButtons() {
    final hangupBtn = ActionButton(
      title: "HangUp",
      onPressed: () => _handleHangup(),
      icon: Icons.call_end,
      fillColor: Colors.red,
    );
    final picUpBtn = ActionButton(
      title: "PicUp",
      onPressed: () {
        _handleAccept();
        },
      icon: Icons.call_sharp,
      fillColor: Colors.green,
    );
    final hangupBtnInactive = ActionButton(
      title: "HangUp",
      onPressed: () {},
      icon: Icons.call_end,
      fillColor: Colors.grey,
    );

    final basicActions = <Widget>[];
    final advanceActions = <Widget>[];

    switch (_state) {
      case CallStateEnum.STREAM:
      case CallStateEnum.NONE:
      case CallStateEnum.CONNECTING:
        if (direction == 'INCOMING') {
          basicActions.add(picUpBtn);
          FlutterRingtonePlayer().playRingtone(looping: true);
        } else {
          basicActions.add(hangupBtn);
          FlutterRingtonePlayer().stop();
        }
        break;
      case CallStateEnum.ACCEPTED:
      case CallStateEnum.CONFIRMED:
        {
          FlutterRingtonePlayer().stop();

          ///Mute & UnMute
          advanceActions.add(ActionButton(
            title: _audioMuted ? 'UnMute' : 'Mute',
            icon: _audioMuted ? Icons.mic_off : Icons.mic,
            checked: _audioMuted,
            onPressed: () => _muteAudio(),
          ));

          ///KeyPad Dialer and CameraSwitch
          // if (voiceOnly) {
          //   advanceActions.add(ActionButton(
          //     title: "keypad",
          //     icon: Icons.dialpad,
          //     onPressed: () => _handleKeyPad(),
          //   ));
          // } else {
          //   advanceActions.add(ActionButton(
          //     title: "Switch Camera",
          //     icon: Icons.switch_video,
          //     onPressed: () => _switchCamera(),
          //   ));
          // }

          /// Speaker on/off ||Camera on/off
          advanceActions.add(ActionButton(
            title: _speakerOn ? 'Speaker Off' : 'Speaker On',
            icon: _speakerOn ? Icons.volume_off : Icons.volume_up,
            checked: _speakerOn,
            onPressed: () => _toggleSpeaker(),
          ));
          // if (voiceOnly) {
          //   advanceActions.add(ActionButton(
          //     title: _speakerOn ? 'Speaker Off' : 'Speaker On',
          //     icon: _speakerOn ? Icons.volume_off : Icons.volume_up,
          //     checked: _speakerOn,
          //     onPressed: () => _toggleSpeaker(),
          //   ));
          // } else {
          //   advanceActions.add(ActionButton(
          //     title: _videoMuted ? "Camera On" : 'Camera Off',
          //     icon: _videoMuted ? Icons.videocam : Icons.videocam_off,
          //     checked: _videoMuted,
          //     onPressed: () => _muteVideo(),
          //   ));
          // }

          ///Hold & UnHold
          basicActions.add(ActionButton(
            title: _hold ? 'UnHold' : 'Hold',
            icon: _hold ? Icons.play_arrow : Icons.pause,
            checked: _hold,
            onPressed: () => _handleHold(),
          ));

          ///HangUp
          basicActions.add(hangupBtn);

          ///BackDialPad || Transfer BTN
          // if (_showNumPad) {
          //   basicActions.add(ActionButton(
          //     title: "Back",
          //     icon: Icons.keyboard_arrow_down,
          //     onPressed: () => _handleKeyPad(),
          //   ));
          // } else {
          //   basicActions.add(ActionButton(
          //     title: "Transfer",
          //     icon: Icons.phone_forwarded,
          //     onPressed: () => _handleTransfer(),
          //   ));
          // }
        }
        break;
      case CallStateEnum.FAILED:
      case CallStateEnum.ENDED:
      FlutterRingtonePlayer().stop();
      call!.hangup();
      _timer?.cancel();
      basicActions.add(hangupBtnInactive);
        break;
      case CallStateEnum.PROGRESS:
        basicActions.add(hangupBtn);
        break;
      default:
        if (kDebugMode) {
          print('Other state => $_state');
        }
        break;
    }

    final actionWidgets = <Widget>[];

    //if (_showNumPad) {
    //  actionWidgets.addAll(_buildNumPad());
    //} else {
      if (advanceActions.isNotEmpty) {
        actionWidgets.add(
          Padding(
            padding: const EdgeInsets.all(3),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: advanceActions),
          ),
        );
      }
    //}

    actionWidgets.add(
      Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: basicActions),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: actionWidgets,
    );
  }
  Widget _buildContent() {
    final size=MediaQuery.of(context).size;
    final stackWidgets = <Widget>[];

    // if (!voiceOnly && _remoteStream != null) {
    //   stackWidgets.add(
    //     Center(
    //       child: RTCVideoView(
    //         _remoteRenderer!,
    //         objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
    //       ),
    //     ),
    //   );
    // }
    //
    // if (!voiceOnly && _localStream != null) {
    //   stackWidgets.add(
    //     AnimatedContainer(
    //       height: _localVideoHeight,
    //       width: _localVideoWidth,
    //       alignment: Alignment.topRight,
    //       duration: const Duration(milliseconds: 300),
    //       margin: _localVideoMargin,
    //       child: RTCVideoView(
    //         _localRenderer!,
    //         mirror: _mirror,
    //         objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
    //       ),
    //     ),
    //   );
    // }

    stackWidgets.addAll(
      [
        Positioned(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: size.height*0.1),
                const CircleAvatar(
                  radius: 70.0,
                  backgroundImage:
                  AssetImage(ImagePath.profilePath),
                ),
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.all(6),
                //     child: Text((voiceOnly ? 'VOICE CALL' : 'VIDEO CALL') + (_hold ? ' PAUSED BY ${_holdOriginator!.toUpperCase()}' : ''),
                //       style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')
                //     ),
                //   ),
                // ),
                SizedBox(height: size.height*0.01),
                Text(
                  '$remoteIdentity',
                  style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 26, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                ),
                SizedBox(height: size.height*0.01),
                Consumer<CallTimerProvider>(
                  builder: (context,val,child) {
                    return Text(
                      _timeLabel=="00:00"?"":_timeLabel,
                      //val.callTimer=="00:00"?"":val.callTimer,
                      style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 18, fontFamily: 'Poppins'),
                    );
                  }
                )
              ],
            ),
          ),
        ),
      ],
    );

    return Stack(
      children: stackWidgets,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('[$direction] ${EnumHelper.getName(_state)}'),
      ),*/
      body: _buildContent(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 24.0),
        child: _buildActionButtons(),
      ),
    );
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
  }
  @override
  void onNewNotify(Notify ntf) {
    print("Call-Screen--->$ntf");
  }

}
