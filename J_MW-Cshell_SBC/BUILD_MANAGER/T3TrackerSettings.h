/*  File:       T3AppTracker.h
    Created:    04 Mar 09
	Author:		Robert P. Sagusti
				Roger M. Mabe

    -	Smart Logic, Inc.
    -	Supporting SDL, Inc. for NRL ATDP
    -	Naval Research Laboratory, Code 5663


    Description:
		Contains the settings for the Tracker Board (Xpedite 7170) in the ATDP CP.
		Global settings for the CP are defined in T3ControlProcessor.h.
		These settings are local to the Tracker Board.

    Planned Upgrades:

    Changes:

*/

#ifndef	_T3TrackerSettings_h_
#define _T3TrackerSettings_h_


/* =======================================================================
	T3AppTracker Task Priorities
   ======================================================================= */
#define kT3AppTracker_T3AppTrackerTaskPriority      21
#define kT3AppTracker_T3LWThreatTaskPriority        30
#define kT3AppTracker_T3NavTaskPriority             48
#define kT3AppTracker_T3ExReadyTaskPriority         47
#define kT3AppTracker_TrackExTaskPriority           50
#define kT3AppTracker_LLTrackExTaskPriority         49
#define kT3AppTracker_AdaTrackExTaskPriority        68
#define kT3AppTracker_DoExWriterTaskPriority        80
#define kT3AppTracker_WriteExTaskPriority           20
#define kT3AppTracker_WriteTracksTaskPriority       21
#define kT3AppTracker_WriteLowLatencyTaskPriority   22
#define kT3AppTracker_DAUTaskPriority               71
#define kT3AppTracker_DecompTaskPriority            72
#define kT3AppTracker_JamCodeWatchDogPriority       90
#define kT3AppTracker_ManageBetaPriority            89
#define kT3AppTracker_FaultLoggerPriority           91
#define kT3AppTracker_CIStatusTaskPriority          92
#define kT3AppTracker_CIControlTaskPriority         92
#define kT3AppTracker_SBITTaskPriority              93
#define kT3AppTracker_JamPowerBITTaskPriority       93
#define kT3AppTracker_InfoLogTaskPriority           99
#define kT3AppTracker_OlftTrackerPriority           70


#define	kT3AdaTrackerTaskPriority                   68



/* =======================================================================
	T3AppTracker Task Names
   ======================================================================= */
#define	kT3AppTracker_T3AppTrackerTaskName       "T3AppTracker"
#define kT3AppTracker_T3LWThreatTaskName         "T3LWThreat"
#define kT3AppTracker_T3NavTaskName              "T3Nav"
#define kT3AppTracker_T3ExReadyTaskName          "T3ExReady"
#define kT3AppTracker_TrackExTaskName            "T3TrackEx"
#define kT3AppTracker_LLTrackExTaskName          "T3LLTrackEx"
#define kT3AppTracker_AdaTrackExTaskName         "T3AdaTrack"
#define kT3AppTracker_DoExWriterTaskName         "T3DoExWriter"
#define kT3AppTracker_WriteExTaskName            "T3WriteEx"
#define kT3AppTracker_WriteTracksTaskName        "T3WriteTrk"
#define kT3AppTracker_WriteLowLatencyTaskName    "T3WriteLL"
#define kT3AppTracker_JamCodeWatchDogTaskName    "T3JamWDTmr"
#define kT3AppTracker_ManageBetaTaskName         "T3BetaMgr"
#define kT3AppTracker_FaultLoggerName            "T3FaultLog"
#define kT3AppTracker_CIStatusTaskName           "CIStatusTask"
#define kT3AppTracker_CIControlTaskName          "CICtrlTask"
#define kT3AppTracker_SBITTaskName               "T3SBITTask"
#define kT3AppTracker_DAUTaskName                "T3DAUTask"
#define kT3AppTracker_DecompTaskName             "T3DecompTask"
#define kT3AppTracker_JamPowerBITTaskName        "JPBTask"
#define kT3AppTracker_InfoLogTaskName	         "T3InfoLog"
#define kT3AppTracker_OlftTrackerName            "OlftTrkrTask"

/* =======================================================================
	T3AppTracker Stack sizes
   ======================================================================= */
#define	kT3AppTracker_T3NAVTaskStackSize        65536
#define kT3AppTracker_T3ExReadyTaskStackSize    65536
#define kT3AppTracker_TrackExTaskStackSize      65536
#define kT3AppTracker_LLTrackExTaskStackSize    65536
#define kT3AppTracker_AdaTrackExTaskStackSize   16*65536
#define kT3AppTracker_DoExWriterTaskStackSize   65536
#define kT3AppTracker_WriteExTaskSize           65536
#define kT3AppTracker_WriteTracksTaskSize       65536
#define kT3AppTracker_WriteLowLatencyTaskSize   65536
#define kT3AppTracker_JamCodeWatchDogSize       65536
#define kT3AppTracker_ManageBetaSize            65536
#define kT3AppTracker_FaultLoggerSize           65536
#define kT3AppTracker_CIStatusTaskSize          65536
#define kT3AppTracker_CIControlTaskSize         65536
#define kT3AppTracker_SBITTaskSize              65536
#define kT3AppTracker_DAUTaskSize               65536
#define kT3AppTracker_DecompTaskSize            65536
#define kT3AppTracker_JamPowerBITTaskSize       65536
#define kT3AppTracker_InfoLogTaskSize	        65536
#define kT3AppTracker_OlftTrackerSize           65536


/* =======================================================================
	T3AppTracker CPU Assignmemnts
   ======================================================================= */
#define kT3AppTracker_T3NavTaskCpu                        3
#define kT3AppTracker_T3ExReadyTaskCpu                    1
#define kT3AppTracker_TrackExTaskCpu                      1
#define kT3AppTracker_LLTrackExTaskCpu                    1
#define kT3AppTracker_AdaTrackExTaskCpu                   2
#define kT3AppTracker_DoExWriterTaskCpu                   3
#define kT3AppTracker_WriteExTaskCpu                      3
#define kT3AppTracker_WriteTracksTaskCpu                  1
#define kT3AppTracker_WriteLowLatencyTaskCpu              0
#define kT3AppTracker_JamCodeWatchDogCpu                  1
#define kT3AppTracker_ManageBetaCpu                       0
#define kT3AppTracker_FaultLoggerCpu                      0
#define kT3AppTracker_CIStatusTaskCpu                     0
#define kT3AppTracker_CIControlTaskCpu                    0
#define kT3AppTracker_SBITTaskCpu                         0
#define kT3AppTracker_DAUTaskCpu                          0
#define kT3AppTracker_DecompTaskCpu                       3
#define kT3AppTracker_JamPowerBITTaskCpu                  0
#define kT3AppTracker_InfoLogTaskCpu	                  0
#define kT3AppTracker_OlftTrackerCpu                      0

/* =======================================================================
	T3AppTracker Task BITS
   ======================================================================= */
#define	kT3AppTracker_T3AppTrackerTaskBit       (1 <<  0)
#define kT3AppTracker_T3LWThreatTaskBit         (1 <<  1)
#define kT3AppTracker_T3NavTaskBit              (1 <<  2)
#define kT3AppTracker_T3ExReadyTaskBit          (1 <<  3)
#define kT3AppTracker_TrackExTaskBit            (1 <<  4)
#define kT3AppTracker_LLTrackExTaskBit          (1 <<  5)
#define kT3AppTracker_AdaTrackExTaskBit         (1 <<  6)
#define kT3AppTracker_DoExWriterTaskBit         (1 <<  7)
#define kT3AppTracker_WriteExTaskBit            (1 <<  8)
#define kT3AppTracker_WriteTracksTaskBit        (1 <<  9)
#define kT3AppTracker_WriteLowLatencyTaskBit    (1 << 10)
#define kT3AppTracker_JamCodeWatchDogTaskBit    (1 << 11)
#define kT3AppTracker_ManageBetaTaskBit         (1 << 12)
#define kT3AppTracker_FaultLoggerBit            (1 << 13)
#define kT3AppTracker_CIStatusTaskBit           (1 << 14)
#define kT3AppTracker_CIControlTaskBit          (1 << 15)
#define kT3AppTracker_SBITTaskBit               (1 << 16)
#define kT3AppTracker_DAUTaskBit                (1 << 17)
#define kT3AppTracker_DecompTaskBit             (1 << 18)

#define kT3NavTask_MainBit                      (1 << 19)
#define kMyTrkrInterruptTaskBit                 (1 << 20)
#define kT3AppTracker_StartupBit                (1 << 21)
#define kT3AppTracker_StartupTaskBit            (1 << 22)
#define kT3AppTracker_JamPowerTaskBit           (1 << 23)
#define kT3AppTracker_InfoLogTaskBit            (1 << 24)
#define kBaringaTaskBit                         (1 << 25)

extern atomic32_t gActiveTaskFlag;

/*	atomic32And(&gActiveTaskFlag, ~kT3AppTracker_StartupBit); */


/* =======================================================================
	T3AppTracker Error Codes
   ======================================================================= */
#define	kT3AppTrackerError_NullPointer			(-1)
#define	kT3AppTrackerError_NotInitialized		(-2)
#define	kT3AppTrackerError_MemoryConfig			(-3)
#define	kT3AppTrackerError_TaskManager			(-4)
#define	kT3AppTrackerError_SensorMode			(-5)
#define	kT3AppTrackerError_Tracker				(-6)
#define	kT3AppTrackerError_INSSocket			(-7)
#define	kT3AppTrackerError_Update				(-8)
#define	kT3AppTrackerError_Enqueue				(-9)
#define	kT3AppTrackerError_MemoryQueue			(-10)
#define	kT3AppTrackerError_INSTask				(-11)
#define	kT3AppTrackerError_SyncTask				(-12)
#define	kT3AppTrackerError_StatusTask			(-13)
#define kT3AppTrackerError_DAIRCMTask			(-14)
#define kT3AppTrackerError_DAIRCMSensorCmdTask	(-15)
#define kT3AppTrackerError_Avionics				(-16)
#define kT3AppTrackerError_RecorderInit			(-17)
#define kT3AppTrackerError_RecorderConnect		(-18)
#define kT3AppTrackerError_DisplayInit			(-19)
#define kT3AppTrackerError_DisplayConnect		(-20)
#define kT3AppTrackerError_DisplaySlot			(-21)
#define kT3AppTrackerError_DisplaySensor		(-22)
#define kT3AppTrackerError_CounterMeasuresTask	(-23)
#define kT3AppTrackerError_ImproperMode			(-24)
#define kT3AppTrackerError_CRCBAD				(-25)
#define kT3AppTrackerError_SensorCmdLink		(-26)
#define kT3AppTrackerError_INSCount				(-27)
#define kT3AppTrackerError_SystemInit			(-28)
#define kT3AppTrackerError_SystemConnect		(-29)
#define kT3AppTrackerError_DDCInterrupt			(-30)
#define kT3AppTrackerError_HandheldTask			(-31)
#define kT3AppTrackerError_SyncCmdLoad			(-32)
#define kT3AppTrackerError_SyncMode				(-33)


/* =======================================================================
	Clock Rates (Hz)
   ======================================================================= */
#define	kT3ControlTask_SysClkRate	200
#define kT3ControlTask_KernTimeSlce	 20





/* =======================================================================
    Tracker Interface Constants

    This must match what the Ada tracker expects, or bad things will
    happen.

    Note that the maximum number of exceedances in the tracker report
    is much larger than the number of exceedances that the Ada tracker
    will accept.
   ======================================================================= */
#define kT3TrackerInterface_ExceedanceSize	   96
#define kT3TrackerInterface_MaxExceedances	 2000
#define kT3TrackerInterface_MaxLLExceedances  256
#define	kT3TrackerInterface_MaxTracks		  500
#define	kT3TrackerInterface_MaxLLTracks		    6
#define kT3AdaTrackRecordTrackMessage         0x1

/* =======================================================================
	ATDP Constants
	These are global across all processors in the ATDP.
	Constants with the "Size" suffix are always in bytes.
   ======================================================================= */

/* ----- Maximum number of sensors ----- */
#define	kT3MaxSensors				4      // WARNING: DO NOT CHANGE THIS!!!!!

/* ----- Each image has dimensions 400x400 (short int pixels) ----- */
#define	kT3MaxImageWidth				256
#define	kT3MaxImageLength				256
#define	kT3MaxImageSize				(kT3ImageWidth * kT3ImageLength * sizeof(short))

/* ----- The max sensor header size in bytes (DAIRCM 2) ----- */
#define	kT3MaxHeaderSize				30720

/* ----- The number of header lines is 2 for TADIRCM and 4 for DAIRCM ----- */
/* This is defined in T3SensorDataControl */
/* ---- INS Header Size ----*/
#define kT3INSHeaderSize      	       256

/* ----- Image line size in bytes ----- */
#define	kT3MaxImageLineSize			(kT3MaxImageWidth * sizeof(short))

/* ---- Max Number of LW Threats ----*/
#define kT3MaxNumberLWThreats  32


/* =======================================================================
	Min and Max BETA settings
   ======================================================================= */
#define kT3MaxBetaSetting (0.10000f)





/* =======================================================================
	TCP Port Numbers
   ======================================================================= */

/* -----------------------------------------------------------------------
    This port is used to send command strings to each of the processors.
    Both UDP and TCP connections are active.
   ----------------------------------------------------------------------- */
#define	kT3CommandProcessorPort	4444

#define kT3Avionics_MaxMWSExceedances  1999 /* 1000 MWS exceedances per sensor */
#define kT3Avionics_MaxHFIExceedances  0000 /* 1000 HFI exceedances per sensor */

#endif
