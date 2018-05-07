TEMPLATE = app

QT += qml quick
CONFIG += c++11

HEADERS += Controller.hpp
HEADERS += linkaudio/AudioEngine.hpp
HEADERS += linkaudio/AudioPlatform.hpp
HEADERS += linkaudio/AudioPlatform_Asio.hpp

SOURCES += main.cpp
SOURCES += Controller.cpp
SOURCES += linkaudio/AudioEngine.cpp
SOURCES += linkaudio/AudioPlatform_Asio.cpp
#SOURCES += ASIOSDK2.3/common/asio.cpp
#SOURCES += ASIOSDK2.3/host/asiodrivers.cpp
#SOURCES += ASIOSDK2.3/host/pc/asiolist.cpp

RESOURCES += resources.qrc

INCLUDEPATH += $$PWD/include
DEPENDPATH += $$PWD/include
INCLUDEPATH += $$PWD/asio-standalone/asio/include
DEPENDPATH += $$PWD/asio-standalone/asio/include

DEFINES -= UNICODE
DEFINES -= _UNICODE
DEFINES += MBCS

win32 : LIBS += -liphlpapi
LIBS += -lws2_32

QMAKE_CFLAGS_WARN_OFF    = -wd4127 -wd4242 -wd4619 -wd4668 -wd4702 -wd4267 -wd4477
QMAKE_CXXFLAGS_WARN_OFF  = $$QMAKE_CFLAGS_WARN_ON

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
