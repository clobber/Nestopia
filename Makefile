
DEBUG = 0

ifeq ($(platform),)
platform = unix
ifeq ($(shell uname -a),)
   platform = win
else ifneq ($(findstring Darwin,$(shell uname -a)),)
   platform = osx
else ifneq ($(findstring MINGW,$(shell uname -a)),)
   platform = win
endif
endif

ifeq ($(platform), unix)
   TARGET := libretro.so
   fpic := -fPIC
   SHARED := -shared -Wl,--no-undefined -Wl,--version-script=link.T
   ENDIANNESS_DEFINES := -DLSB_FIRST
   LDFLAGS +=
   FLAGS += -DHAVE_MKDIR
else ifeq ($(platform), osx)
   TARGET := libretro.dylib
   STATICLIB := libretro.a
   fpic := -fPIC
   SHARED := -dynamiclib
   ENDIANNESS_DEFINES := -DLSB_FIRST
   LDFLAGS +=
   FLAGS += -DHAVE_MKDIR
else
   TARGET := retro.dll
   CC = gcc
   CXX = g++
   SHARED := -shared -Wl,--no-undefined -Wl,--version-script=link.T
   LDFLAGS += -static-libgcc -static-libstdc++ -lwinmm
   ENDIANNESS_DEFINES := -DLSB_FIRST
   FLAGS += -DHAVE__MKDIR
endif
NESTOPIA_DIR := core

NESTOPIA_SOURCES := $(NESTOPIA_DIR)/api/NstApiBarcodeReader.cpp \
	$(NESTOPIA_DIR)/api/NstApiCartridge.cpp \
	$(NESTOPIA_DIR)/api/NstApiCheats.cpp \
	$(NESTOPIA_DIR)/api/NstApiDipSwitches.cpp \
	$(NESTOPIA_DIR)/api/NstApiEmulator.cpp \
	$(NESTOPIA_DIR)/api/NstApiFds.cpp \
	$(NESTOPIA_DIR)/api/NstApiInput.cpp \
	$(NESTOPIA_DIR)/api/NstApiMachine.cpp \
	$(NESTOPIA_DIR)/api/NstApiMovie.cpp \
	$(NESTOPIA_DIR)/api/NstApiNsf.cpp \
	$(NESTOPIA_DIR)/api/NstApiRewinder.cpp \
	$(NESTOPIA_DIR)/api/NstApiSound.cpp \
	$(NESTOPIA_DIR)/api/NstApiTapeRecorder.cpp \
	$(NESTOPIA_DIR)/api/NstApiUser.cpp \
	$(NESTOPIA_DIR)/api/NstApiVideo.cpp \
	$(NESTOPIA_DIR)/board/NstBoard.cpp \
	$(NESTOPIA_DIR)/board/NstBoardAe.cpp \
	$(NESTOPIA_DIR)/board/NstBoardAgci.cpp \
	$(NESTOPIA_DIR)/board/NstBoardAveD1012.cpp \
	$(NESTOPIA_DIR)/board/NstBoardAveNina.cpp \
	$(NESTOPIA_DIR)/board/NstBoardAxRom.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBandai24c0x.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBandaiAerobicsStudio.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBandaiDatach.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBandaiKaraokeStudio.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBandaiLz93d50.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBandaiLz93d50ex.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBandaiOekaKids.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBenshengBs5.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc110in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc1200in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc150in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc15in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc20in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc21in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc22Games.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc31in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc35in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc36in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc64in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc72in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc76in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc800in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc8157.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmc9999999in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcA65as.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcBallgames11in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcCh001.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcCtc65.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcFamily4646B.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcFk23c.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcGamestarA.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcGamestarB.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcGolden190in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcGoldenCard6in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcGoldenGame260in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcHero.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcMarioParty7in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcNovelDiamond.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcPowerjoy84in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcResetBased4in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcSuper22Games.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcSuper24in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcSuper40in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcSuper700in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcSuperBig7in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcSuperGun20in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcSuperHiK300in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcSuperHiK4in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcSuperVision16in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcT262.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcVrc4.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcVt5201.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBmcY2k64in1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtl2708.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtl6035052.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtlAx5705.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtlDragonNinja.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtlGeniusMerioBros.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtlMarioBaby.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtlPikachuY2k.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtlShuiGuanPipe.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtlSmb2a.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtlSmb2b.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtlSmb2c.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtlSmb3.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtlSuperBros11.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtlT230.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBtlTobidaseDaisakusen.cpp \
	$(NESTOPIA_DIR)/board/NstBoardBxRom.cpp \
	$(NESTOPIA_DIR)/board/NstBoardCaltron.cpp \
	$(NESTOPIA_DIR)/board/NstBoardCamerica.cpp \
	$(NESTOPIA_DIR)/board/NstBoardCneDecathlon.cpp \
	$(NESTOPIA_DIR)/board/NstBoardCnePsb.cpp \
	$(NESTOPIA_DIR)/board/NstBoardCneShlz.cpp \
	$(NESTOPIA_DIR)/board/NstBoardCony.cpp \
	$(NESTOPIA_DIR)/board/NstBoardCxRom.cpp \
	$(NESTOPIA_DIR)/board/NstBoardDiscrete.cpp \
	$(NESTOPIA_DIR)/board/NstBoardDreamtech.cpp \
	$(NESTOPIA_DIR)/board/NstBoardEvent.cpp \
	$(NESTOPIA_DIR)/board/NstBoardFb.cpp \
	$(NESTOPIA_DIR)/board/NstBoardFfe.cpp \
	$(NESTOPIA_DIR)/board/NstBoardFujiya.cpp \
	$(NESTOPIA_DIR)/board/NstBoardFukutake.cpp \
	$(NESTOPIA_DIR)/board/NstBoardFutureMedia.cpp \
	$(NESTOPIA_DIR)/board/NstBoardGouder.cpp \
	$(NESTOPIA_DIR)/board/NstBoardGxRom.cpp \
	$(NESTOPIA_DIR)/board/NstBoardHes.cpp \
	$(NESTOPIA_DIR)/board/NstBoardHosenkan.cpp \
	$(NESTOPIA_DIR)/board/NstBoardIremG101.cpp \
	$(NESTOPIA_DIR)/board/NstBoardIremH3001.cpp \
	$(NESTOPIA_DIR)/board/NstBoardIremHolyDiver.cpp \
	$(NESTOPIA_DIR)/board/NstBoardIremKaiketsu.cpp \
	$(NESTOPIA_DIR)/board/NstBoardIremLrog017.cpp \
	$(NESTOPIA_DIR)/board/NstBoardJalecoJf11.cpp \
	$(NESTOPIA_DIR)/board/NstBoardJalecoJf13.cpp \
	$(NESTOPIA_DIR)/board/NstBoardJalecoJf16.cpp \
	$(NESTOPIA_DIR)/board/NstBoardJalecoJf17.cpp \
	$(NESTOPIA_DIR)/board/NstBoardJalecoJf19.cpp \
	$(NESTOPIA_DIR)/board/NstBoardJalecoSs88006.cpp \
	$(NESTOPIA_DIR)/board/NstBoardJyCompany.cpp \
	$(NESTOPIA_DIR)/board/NstBoardKaiser.cpp \
	$(NESTOPIA_DIR)/board/NstBoardKasing.cpp \
	$(NESTOPIA_DIR)/board/NstBoardKayH2288.cpp \
	$(NESTOPIA_DIR)/board/NstBoardKayPandaPrince.cpp \
	$(NESTOPIA_DIR)/board/NstBoardKonamiVrc1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardKonamiVrc2.cpp \
	$(NESTOPIA_DIR)/board/NstBoardKonamiVrc3.cpp \
	$(NESTOPIA_DIR)/board/NstBoardKonamiVrc4.cpp \
	$(NESTOPIA_DIR)/board/NstBoardKonamiVrc6.cpp \
	$(NESTOPIA_DIR)/board/NstBoardKonamiVrc7.cpp \
	$(NESTOPIA_DIR)/board/NstBoardKonamiVsSystem.cpp \
	$(NESTOPIA_DIR)/board/NstBoardMagicSeries.cpp \
	$(NESTOPIA_DIR)/board/NstBoardMmc1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardMmc2.cpp \
	$(NESTOPIA_DIR)/board/NstBoardMmc3.cpp \
	$(NESTOPIA_DIR)/board/NstBoardMmc4.cpp \
	$(NESTOPIA_DIR)/board/NstBoardMmc5.cpp \
	$(NESTOPIA_DIR)/board/NstBoardMmc6.cpp \
	$(NESTOPIA_DIR)/board/NstBoardNamcot163.cpp \
	$(NESTOPIA_DIR)/board/NstBoardNamcot34xx.cpp \
	$(NESTOPIA_DIR)/board/NstBoardNanjing.cpp \
	$(NESTOPIA_DIR)/board/NstBoardNihon.cpp \
	$(NESTOPIA_DIR)/board/NstBoardNitra.cpp \
	$(NESTOPIA_DIR)/board/NstBoardNtdec.cpp \
	$(NESTOPIA_DIR)/board/NstBoardOpenCorp.cpp \
	$(NESTOPIA_DIR)/board/NstBoardQj.cpp \
	$(NESTOPIA_DIR)/board/NstBoardRcm.cpp \
	$(NESTOPIA_DIR)/board/NstBoardRexSoftDb5z.cpp \
	$(NESTOPIA_DIR)/board/NstBoardRexSoftSl1632.cpp \
	$(NESTOPIA_DIR)/board/NstBoardRumbleStation.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSachen74x374.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSachenS8259.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSachenSa0036.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSachenSa0037.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSachenSa72007.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSachenSa72008.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSachenStreetHeroes.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSachenTca01.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSachenTcu.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSomeriTeamSl12.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSubor.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSunsoft1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSunsoft2.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSunsoft3.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSunsoft4.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSunsoft5b.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSunsoftDcs.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSunsoftFme7.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSuperGameBoogerman.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSuperGameLionKing.cpp \
	$(NESTOPIA_DIR)/board/NstBoardSuperGamePocahontas2.cpp \
	$(NESTOPIA_DIR)/board/NstBoardTaitoTc0190fmc.cpp \
	$(NESTOPIA_DIR)/board/NstBoardTaitoTc0190fmcPal16r4.cpp \
	$(NESTOPIA_DIR)/board/NstBoardTaitoX1005.cpp \
	$(NESTOPIA_DIR)/board/NstBoardTaitoX1017.cpp \
	$(NESTOPIA_DIR)/board/NstBoardTengen.cpp \
	$(NESTOPIA_DIR)/board/NstBoardTengenRambo1.cpp \
	$(NESTOPIA_DIR)/board/NstBoardTxc.cpp \
	$(NESTOPIA_DIR)/board/NstBoardTxcMxmdhtwo.cpp \
	$(NESTOPIA_DIR)/board/NstBoardTxcPoliceman.cpp \
	$(NESTOPIA_DIR)/board/NstBoardTxcTw.cpp \
	$(NESTOPIA_DIR)/board/NstBoardTxRom.cpp \
	$(NESTOPIA_DIR)/board/NstBoardUnlCc21.cpp \
	$(NESTOPIA_DIR)/board/NstBoardUnlEdu2000.cpp \
	$(NESTOPIA_DIR)/board/NstBoardUnlKingOfFighters96.cpp \
	$(NESTOPIA_DIR)/board/NstBoardUnlKingOfFighters97.cpp \
	$(NESTOPIA_DIR)/board/NstBoardUnlMortalKombat2.cpp \
	$(NESTOPIA_DIR)/board/NstBoardUnlSuperFighter3.cpp \
	$(NESTOPIA_DIR)/board/NstBoardUnlTf1201.cpp \
	$(NESTOPIA_DIR)/board/NstBoardUnlWorldHero.cpp \
	$(NESTOPIA_DIR)/board/NstBoardUnlXzy.cpp \
	$(NESTOPIA_DIR)/board/NstBoardUxRom.cpp \
	$(NESTOPIA_DIR)/board/NstBoardVsSystem.cpp \
	$(NESTOPIA_DIR)/board/NstBoardWaixing.cpp \
	$(NESTOPIA_DIR)/board/NstBoardWaixingFfv.cpp \
	$(NESTOPIA_DIR)/board/NstBoardWaixingPs2.cpp \
	$(NESTOPIA_DIR)/board/NstBoardWaixingSecurity.cpp \
	$(NESTOPIA_DIR)/board/NstBoardWaixingSgz.cpp \
	$(NESTOPIA_DIR)/board/NstBoardWaixingSgzlz.cpp \
	$(NESTOPIA_DIR)/board/NstBoardWaixingSh2.cpp \
	$(NESTOPIA_DIR)/board/NstBoardWaixingZs.cpp \
	$(NESTOPIA_DIR)/board/NstBoardWhirlwind.cpp \
	$(NESTOPIA_DIR)/board/NstBoardZz.cpp \
	$(NESTOPIA_DIR)/input/NstInpAdapter.cpp \
	$(NESTOPIA_DIR)/input/NstInpBandaiHyperShot.cpp \
	$(NESTOPIA_DIR)/input/NstInpBarcodeWorld.cpp \
	$(NESTOPIA_DIR)/input/NstInpCrazyClimber.cpp \
	$(NESTOPIA_DIR)/input/NstInpDoremikkoKeyboard.cpp \
	$(NESTOPIA_DIR)/input/NstInpExcitingBoxing.cpp \
	$(NESTOPIA_DIR)/input/NstInpFamilyKeyboard.cpp \
	$(NESTOPIA_DIR)/input/NstInpFamilyTrainer.cpp \
	$(NESTOPIA_DIR)/input/NstInpHoriTrack.cpp \
	$(NESTOPIA_DIR)/input/NstInpKonamiHyperShot.cpp \
	$(NESTOPIA_DIR)/input/NstInpMahjong.cpp \
	$(NESTOPIA_DIR)/input/NstInpMouse.cpp \
	$(NESTOPIA_DIR)/input/NstInpOekaKidsTablet.cpp \
	$(NESTOPIA_DIR)/input/NstInpPachinko.cpp \
	$(NESTOPIA_DIR)/input/NstInpPad.cpp \
	$(NESTOPIA_DIR)/input/NstInpPaddle.cpp \
	$(NESTOPIA_DIR)/input/NstInpPartyTap.cpp \
	$(NESTOPIA_DIR)/input/NstInpPokkunMoguraa.cpp \
	$(NESTOPIA_DIR)/input/NstInpPowerGlove.cpp \
	$(NESTOPIA_DIR)/input/NstInpPowerPad.cpp \
	$(NESTOPIA_DIR)/input/NstInpRob.cpp \
	$(NESTOPIA_DIR)/input/NstInpSuborKeyboard.cpp \
	$(NESTOPIA_DIR)/input/NstInpTopRider.cpp \
	$(NESTOPIA_DIR)/input/NstInpTurboFile.cpp \
	$(NESTOPIA_DIR)/input/NstInpZapper.cpp \
	$(NESTOPIA_DIR)/NstApu.cpp \
	$(NESTOPIA_DIR)/NstAssert.cpp \
	$(NESTOPIA_DIR)/NstCartridge.cpp \
	$(NESTOPIA_DIR)/NstCartridgeInes.cpp \
	$(NESTOPIA_DIR)/NstCartridgeRomset.cpp \
	$(NESTOPIA_DIR)/NstCartridgeUnif.cpp \
	$(NESTOPIA_DIR)/NstCheats.cpp \
	$(NESTOPIA_DIR)/NstChecksum.cpp \
	$(NESTOPIA_DIR)/NstChips.cpp \
	$(NESTOPIA_DIR)/NstCore.cpp \
	$(NESTOPIA_DIR)/NstCpu.cpp \
	$(NESTOPIA_DIR)/NstCrc32.cpp \
	$(NESTOPIA_DIR)/NstFds.cpp \
	$(NESTOPIA_DIR)/NstFile.cpp \
	$(NESTOPIA_DIR)/NstImage.cpp \
	$(NESTOPIA_DIR)/NstImageDatabase.cpp \
	$(NESTOPIA_DIR)/NstLog.cpp \
	$(NESTOPIA_DIR)/NstMachine.cpp \
	$(NESTOPIA_DIR)/NstMemory.cpp \
	$(NESTOPIA_DIR)/NstNsf.cpp \
	$(NESTOPIA_DIR)/NstPatcher.cpp \
	$(NESTOPIA_DIR)/NstPatcherIps.cpp \
	$(NESTOPIA_DIR)/NstPatcherUps.cpp \
	$(NESTOPIA_DIR)/NstPins.cpp \
	$(NESTOPIA_DIR)/NstPpu.cpp \
	$(NESTOPIA_DIR)/NstProperties.cpp \
	$(NESTOPIA_DIR)/NstRam.cpp \
	$(NESTOPIA_DIR)/NstSha1.cpp \
	$(NESTOPIA_DIR)/NstSoundPcm.cpp \
	$(NESTOPIA_DIR)/NstSoundPlayer.cpp \
	$(NESTOPIA_DIR)/NstSoundRenderer.cpp \
	$(NESTOPIA_DIR)/NstState.cpp \
	$(NESTOPIA_DIR)/NstStream.cpp \
	$(NESTOPIA_DIR)/NstTracker.cpp \
	$(NESTOPIA_DIR)/NstTrackerMovie.cpp \
	$(NESTOPIA_DIR)/NstTrackerRewinder.cpp \
	$(NESTOPIA_DIR)/NstVector.cpp \
	$(NESTOPIA_DIR)/NstVideoFilterNone.cpp \
	$(NESTOPIA_DIR)/NstVideoFilterNtsc.cpp \
	$(NESTOPIA_DIR)/NstVideoRenderer.cpp \
	$(NESTOPIA_DIR)/NstVideoScreen.cpp \
	$(NESTOPIA_DIR)/NstXml.cpp \
	$(NESTOPIA_DIR)/NstZlib.cpp \
	$(NESTOPIA_DIR)/vssystem/NstVsRbiBaseball.cpp \
	$(NESTOPIA_DIR)/vssystem/NstVsSuperXevious.cpp \
	$(NESTOPIA_DIR)/vssystem/NstVsSystem.cpp \
	$(NESTOPIA_DIR)/vssystem/NstVsTkoBoxing.cpp \
	$(NESTOPIA_DIR)/api/NstApiRam.cpp

NESTOPIA_C_SOURCES := $(NESTOPIA_DIR)/NstVideoFilterNtscCfg.c

#LIBRETRO_SOURCES := libretro.c

SOURCES := $(LIBRETRO_SOURCES) $(NESTOPIA_SOURCES)
OBJECTS := $(SOURCES:.cpp=.o) $(NESTOPIA_C_SOURCES:.c=.o)

all: $(TARGET) $(STATICLIB)

ifeq ($(DEBUG),0)
   FLAGS += -O3 -ffast-math -funroll-loops 
else
   FLAGS += -O0 -g
endif

LDFLAGS += $(fpic) -lz $(SHARED)
FLAGS += -msse -msse2 -Wall $(fpic) -fno-strict-overflow
FLAGS += -I. -Icore -Icore/api -Icore/board -Icore/database -Icore/input -Icore/vssystem

WARNINGS := -Wall \
	-Wno-narrowing \
	-Wno-unused-but-set-variable \
	-Wno-sign-compare \
	-Wno-unused-variable \
	-Wno-unused-function \
	-Wno-uninitialized \
	-Wno-unused-result \
	-Wno-strict-aliasing \
	-Wno-overflow

FLAGS += -DLSB_FIRST -DHAVE_MKDIR -DSIZEOF_DOUBLE=8 $(WARNINGS)


CXXFLAGS += $(FLAGS) -DNST_NO_HQ2X -DNST_NO_ZLIB -DNST_NO_SCALEX -DNST_NO_2XSAI
CFLAGS += $(FLAGS) -std=gnu99

$(TARGET): $(OBJECTS)
	$(CXX) -o $@ $^ $(LDFLAGS)
	
$(STATICLIB): $(OBJECTS)
	ar rcs $(STATICLIB) $(OBJECTS)

%.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS)

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

clean:
	rm -f $(TARGET) $(OBJECTS) $(STATICLIB)

.PHONY: clean
