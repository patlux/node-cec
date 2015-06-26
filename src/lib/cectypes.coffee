# from: https://github.com/Pulse-Eight/libcec/blob/master/include/cectypes.h

module.exports =

  VendorId:
    TOSHIBA:            0x000039
    SAMSUNG:            0x0000F0
    DENON:              0x0005CD
    MARANTZ:            0x000678
    LOEWE:              0x000982
    ONKYO:              0x0009B0
    MEDION:             0x000CB8
    TOSHIBA2:           0x000CE7
    PULSE_EIGHT:        0x001582
    HARMAN_KARDON2:     0x001950
    GOOGLE:             0x001A11
    AKAI:               0x0020C7
    AOC:                0x002467
    PANASONIC:          0x008045
    PHILIPS:            0x00903E
    DAEWOO:             0x009053
    YAMAHA:             0x00A0DE
    GRUNDIG:            0x00D0D5
    PIONEER:            0x00E036
    LG:                 0x00E091
    SHARP:              0x08001F
    SONY:               0x080046
    BROADCOM:           0x18C086
    VIZIO:              0x6B746D
    BENQ:               0x8065E9
    HARMAN_KARDON:      0x9C645E
    UNKNOWN:            0

  LogicalAddress:
    UNKNOWN:                       -1 # not a valid logical address
    TV:                            0
    RECORDINGDEVICE1:              1
    RECORDINGDEVICE2:              2
    TUNER1:                        3
    PLAYBACKDEVICE1:               4
    AUDIOSYSTEM:                   5
    TUNER2:                        6
    TUNER3:                        7
    PLAYBACKDEVICE2:               8
    RECORDINGDEVICE3:              9
    TUNER4:                        10
    PLAYBACKDEVICE3:               11
    RESERVED1:                     12
    RESERVED2:                     13
    FREEUSE:                       14
    UNREGISTERED:                  15 # for source
    BROADCAST:                     15  # for target


  Opcode:
    ACTIVE_SOURCE:                 0x82
    IMAGE_VIEW_ON:                 0x04
    TEXT_VIEW_ON:                  0x0D
    INACTIVE_SOURCE:               0x9D
    REQUEST_ACTIVE_SOURCE:         0x85
    ROUTING_CHANGE:                0x80
    ROUTING_INFORMATION:           0x81
    SET_STREAM_PATH:               0x86
    STANDBY:                       0x36
    RECORD_OFF:                    0x0B
    RECORD_ON:                     0x09
    RECORD_STATUS:                 0x0A
    RECORD_TV_SCREEN:              0x0F
    CLEAR_ANALOGUE_TIMER:          0x33
    CLEAR_DIGITAL_TIMER:           0x99
    CLEAR_EXTERNAL_TIMER:          0xA1
    SET_ANALOGUE_TIMER:            0x34
    SET_DIGITAL_TIMER:             0x97
    SET_EXTERNAL_TIMER:            0xA2
    SET_TIMER_PROGRAM_TITLE:       0x67
    TIMER_CLEARED_STATUS:          0x43
    TIMER_STATUS:                  0x35
    CEC_VERSION:                   0x9E
    GET_CEC_VERSION:               0x9F
    GIVE_PHYSICAL_ADDRESS:         0x83
    GET_MENU_LANGUAGE:             0x91
    REPORT_PHYSICAL_ADDRESS:       0x84
    SET_MENU_LANGUAGE:             0x32
    DECK_CONTROL:                  0x42
    DECK_STATUS:                   0x1B
    GIVE_DECK_STATUS:              0x1A
    PLAY:                          0x41
    GIVE_TUNER_DEVICE_STATUS:      0x08
    SELECT_ANALOGUE_SERVICE:       0x92
    SELECT_DIGITAL_SERVICE:        0x93
    TUNER_DEVICE_STATUS:           0x07
    TUNER_STEP_DECREMENT:          0x06
    TUNER_STEP_INCREMENT:          0x05
    DEVICE_VENDOR_ID:              0x87
    GIVE_DEVICE_VENDOR_ID:         0x8C
    VENDOR_COMMAND:                0x89
    VENDOR_COMMAND_WITH_ID:        0xA0
    VENDOR_REMOTE_BUTTON_DOWN:     0x8A
    VENDOR_REMOTE_BUTTON_UP:       0x8B
    SET_OSD_STRING:                0x64
    GIVE_OSD_NAME:                 0x46
    SET_OSD_NAME:                  0x47
    MENU_REQUEST:                  0x8D
    MENU_STATUS:                   0x8E
    USER_CONTROL_PRESSED:          0x44
    USER_CONTROL_RELEASE:          0x45
    GIVE_DEVICE_POWER_STATUS:      0x8F
    REPORT_POWER_STATUS:           0x90
    FEATURE_ABORT:                 0x00
    ABORT:                         0xFF
    GIVE_AUDIO_STATUS:             0x71
    GIVE_SYSTEM_AUDIO_MODE_STATUS: 0x7D
    REPORT_AUDIO_STATUS:           0x7A
    SET_SYSTEM_AUDIO_MODE:         0x72
    SYSTEM_AUDIO_MODE_REQUEST:     0x70
    SYSTEM_AUDIO_MODE_STATUS:      0x7E
    SET_AUDIO_RATE:                0x9A

    # CEC 1.4
    START_ARC:                    0xC0
    REPORT_ARC_STARTED:           0xC1
    REPORT_ARC_ENDED:             0xC2
    REQUEST_ARC_START:            0xC3
    REQUEST_ARC_END:              0xC4
    END_ARC:                      0xC5
    CDC:                          0xF8
    # when this opcode is set no opcode will be sent to the device. this is one of the reserved numbers
    NONE:                         0xFD


  UserControlCode:
    SELECT:                       0x00
    UP:                           0x01
    DOWN:                         0x02
    LEFT:                         0x03
    RIGHT:                        0x04
    RIGHT_UP:                     0x05
    RIGHT_DOWN:                   0x06
    LEFT_UP:                      0x07
    LEFT_DOWN:                    0x08
    ROOT_MENU:                    0x09
    SETUP_MENU:                   0x0A
    CONTENTS_MENU:                0x0B
    FAVORITE_MENU:                0x0C
    EXIT:                         0x0D
    # reserved: 0x0E, 0x0F
    TOP_MENU:                     0x10
    DVD_MENU:                     0x11
    # reserved: 0x12 ... 0x1C
    NUMBER_ENTRY_MODE:            0x1D
    NUMBER11:                     0x1E
    NUMBER12:                     0x1F
    NUMBER0:                      0x20
    NUMBER1:                      0x21
    NUMBER2:                      0x22
    NUMBER3:                      0x23
    NUMBER4:                      0x24
    NUMBER5:                      0x25
    NUMBER6:                      0x26
    NUMBER7:                      0x27
    NUMBER8:                      0x28
    NUMBER9:                      0x29
    DOT:                          0x2A
    ENTER:                        0x2B
    CLEAR:                        0x2C
    NEXT_FAVORITE:                0x2F
    CHANNEL_UP:                   0x30
    CHANNEL_DOWN:                 0x31
    PREVIOUS_CHANNEL:             0x32
    SOUND_SELECT:                 0x33
    INPUT_SELECT:                 0x34
    DISPLAY_INFORMATION:          0x35
    HELP:                         0x36
    PAGE_UP:                      0x37
    PAGE_DOWN:                    0x38
    # reserved: 0x39 ... 0x3F
    POWER:                        0x40
    VOLUME_UP:                    0x41
    VOLUME_DOWN:                  0x42
    MUTE:                         0x43
    PLAY:                         0x44
    STOP:                         0x45
    PAUSE:                        0x46
    RECORD:                       0x47
    REWIND:                       0x48
    FAST_FORWARD:                 0x49
    EJECT:                        0x4A
    FORWARD:                      0x4B
    BACKWARD:                     0x4C
    STOP_RECORD:                  0x4D
    PAUSE_RECORD:                 0x4E
    # reserved: 0x4F
    ANGLE:                        0x50
    SUB_PICTURE:                  0x51
    VIDEO_ON_DEMAND:              0x52
    ELECTRONIC_PROGRAM_GUIDE:     0x53
    TIMER_PROGRAMMING:            0x54
    INITIAL_CONFIGURATION:        0x55
    SELECT_BROADCAST_TYPE:        0x56
    SELECT_SOUND_PRESENTATION:    0x57
    # reserved: 0x58 ... 0x5F
    PLAY_FUNCTION:                0x60
    PAUSE_PLAY_FUNCTION:          0x61
    RECORD_FUNCTION:              0x62
    PAUSE_RECORD_FUNCTION:        0x63
    STOP_FUNCTION:                0x64
    MUTE_FUNCTION:                0x65
    RESTORE_VOLUME_FUNCTION:      0x66
    TUNE_FUNCTION:                0x67
    SELECT_MEDIA_FUNCTION:        0x68
    SELECT_AV_INPUT_FUNCTION:     0x69
    SELECT_AUDIO_INPUT_FUNCTION:  0x6A
    POWER_TOGGLE_FUNCTION:        0x6B
    POWER_OFF_FUNCTION:           0x6C
    POWER_ON_FUNCTION:            0x6D
    # reserved: 0x6E ... 0x70
    F1_BLUE:                      0x71
    F2_RED:                       0x72
    F3_GREEN:                     0x73
    F4_YELLOW:                    0x74
    F5:                           0x75
    DATA:                         0x76
    # reserved: 0x77 ... 0xFF
    AN_RETURN:                    0x91 # return (Samsung)
    AN_CHANNELS_LIST:             0x96 # channels list (Samsung)
    MAX:                          0x96
    UNKNOWN:                      0xFF

  PowerStatus:
    ON:                           0x00
    STANDBY:                      0x01
    IN_TRANSITION_STANDBY_TO_ON:  0x02
    IN_TRANSITION_ON_TO_STANDBY:  0x03
    UNKNOWN:                      0x99
