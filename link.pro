TEMPLATE = app

QT += qml quick
CONFIG += c++11
CONFIG += network

HEADERS += Controller.hpp
HEADERS += linkaudio/AudioEngine.hpp
HEADERS += linkaudio/AudioPlatform.hpp
HEADERS += linkaudio/AudioPlatform_Asio.hpp
HEADERS += $$PWD/include/ableton/*
HEADERS += $$PWD/include/ableton/discovery/*
HEADERS += $$PWD/include/ableton/discovery/test/*
HEADERS += $$PWD/include/ableton/discovery/v1/*
HEADERS += $$PWD/include/ableton/link/*
HEADERS += $$PWD/include/ableton/link/v1/*
HEADERS += $$PWD/include/ableton/platforms/*
HEADERS += $$PWD/include/ableton/platforms/asio/*
HEADERS += $$PWD/include/ableton/platforms/darwin/*
HEADERS += $$PWD/include/ableton/platforms/linux/*
HEADERS += $$PWD/include/ableton/platforms/posix/*
HEADERS += $$PWD/include/ableton/platforms/stl/*
HEADERS += $$PWD/include/ableton/platforms/windows/*
HEADERS += $$PWD/include/ableton/test/*
HEADERS += $$PWD/include/ableton/test/serial_io/*
HEADERS += $$PWD/include/ableton/util/*
HEADERS += $$PWD/include/ableton/util/test/*

SOURCES += main.cpp
SOURCES += Controller.cpp
SOURCES += linkaudio/AudioEngine.cpp
SOURCES += linkaudio/AudioPlatform_Asio.cpp

RESOURCES += resources.qrc

INCLUDEPATH += $$PWD/include
DEPENDPATH += $$PWD/include
INCLUDEPATH += $$PWD/asio-standalone/asio/include
DEPENDPATH += $$PWD/asio-standalone/asio/include

win32: DEFINES += LINK_PLATFORM_WINDOWS
macx : DEFINES += LINK_PLATFORM_MACOSX
DEFINES += LINKHUT_AUDIO_PLATFORM_ASIO

win32 : LIBS += -liphlpapi
win32 : LIBS += -lws2_32

QMAKE_CFLAGS_WARN_OFF    = -wd4127 -wd4242 -wd4619 -wd4668 -wd4702 -wd4267 -wd4477
QMAKE_CXXFLAGS_WARN_OFF  = $$QMAKE_CFLAGS_WARN_ON

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
