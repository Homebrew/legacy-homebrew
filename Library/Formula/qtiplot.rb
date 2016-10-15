require "formula"

class Qtiplot < Formula
  homepage "http://www.qtiplot.com"
  url "https://downloads.sourceforge.net/project/qtiplot.berlios/qtiplot-0.9.8.9.tar.bz2"
  sha1 "73b17dd9195c3d86750d5f1f5bdd4d5483c5fe30"

  depends_on "alglib"
  depends_on "gsl"
  depends_on "liborigin2"
  depends_on "libpng"
  depends_on "muparser"
  depends_on "qt"
  depends_on "quazip"
  depends_on "sip"
  depends_on "pyqt"
  depends_on "tamuanova"

  patch :DATA

  def install
    system "qmake", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "false"
  end
end

__END__

diff -Naur qtiplot-0.9.8.9/3rdparty/qt-assistant-client/include/QtAssistant qtiplot-0.9.8.9.patch.ok/3rdparty/qt-assistant-client/include/QtAssistant
--- qtiplot-0.9.8.9/3rdparty/qt-assistant-client/include/QtAssistant	1970-01-01 01:00:00.000000000 +0100
+++ qtiplot-0.9.8.9.patch.ok/3rdparty/qt-assistant-client/include/QtAssistant	2014-09-11 23:52:45.000000000 +0200
@@ -0,0 +1,5 @@
+#ifndef QT_QTASSISTANT_MODULE_H
+#define QT_QTASSISTANT_MODULE_H
+#include <QtNetwork/QtNetwork>
+#include "qassistantclient.h"
+#endif
diff -Naur qtiplot-0.9.8.9/3rdparty/qt-assistant-client/include/qassistantclient.h qtiplot-0.9.8.9.patch.ok/3rdparty/qt-assistant-client/include/qassistantclient.h
--- qtiplot-0.9.8.9/3rdparty/qt-assistant-client/include/qassistantclient.h	1970-01-01 01:00:00.000000000 +0100
+++ qtiplot-0.9.8.9.patch.ok/3rdparty/qt-assistant-client/include/qassistantclient.h	2014-09-11 23:52:45.000000000 +0200
@@ -0,0 +1,100 @@
+/****************************************************************************
+**
+** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
+** All rights reserved.
+** Contact: Nokia Corporation (qt-info@nokia.com)
+**
+** This file is part of the Qt Assistant of the Qt Toolkit.
+**
+** $QT_BEGIN_LICENSE:LGPL$
+** Commercial Usage
+** Licensees holding valid Qt Commercial licenses may use this file in
+** accordance with the Qt Commercial License Agreement provided with the
+** Software or, alternatively, in accordance with the terms contained in
+** a written agreement between you and Nokia.
+**
+** GNU Lesser General Public License Usage
+** Alternatively, this file may be used under the terms of the GNU Lesser
+** General Public License version 2.1 as published by the Free Software
+** Foundation and appearing in the file LICENSE.LGPL included in the
+** packaging of this file.  Please review the following information to
+** ensure the GNU Lesser General Public License version 2.1 requirements
+** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
+**
+** In addition, as a special exception, Nokia gives you certain additional
+** rights.  These rights are described in the Nokia Qt LGPL Exception
+** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
+**
+** GNU General Public License Usage
+** Alternatively, this file may be used under the terms of the GNU
+** General Public License version 3.0 as published by the Free Software
+** Foundation and appearing in the file LICENSE.GPL included in the
+** packaging of this file.  Please review the following information to
+** ensure the GNU General Public License version 3.0 requirements will be
+** met: http://www.gnu.org/copyleft/gpl.html.
+**
+** If you have questions regarding the use of this file, please contact
+** Nokia at qt-info@nokia.com.
+** $QT_END_LICENSE$
+**
+****************************************************************************/
+
+#ifndef QASSISTANTCLIENT_H
+#define QASSISTANTCLIENT_H
+
+#include <QtCore/QObject>
+#include <QtCore/QStringList>
+#include <QtCore/QProcess>
+#include <QtCore/qglobal.h>
+#include "qassistantclient_global.h"
+
+QT_BEGIN_HEADER
+
+QT_BEGIN_NAMESPACE
+
+class QTcpSocket;
+
+class QT_ASSISTANT_CLIENT_EXPORT QAssistantClient : public QObject
+{
+    Q_OBJECT
+    Q_PROPERTY( bool open READ isOpen )
+
+public:
+    QAssistantClient( const QString &path, QObject *parent = 0);
+    ~QAssistantClient();
+
+    bool isOpen() const;
+
+    void setArguments( const QStringList &args );
+
+public Q_SLOTS:
+    virtual void openAssistant();
+    virtual void closeAssistant();
+    virtual void showPage( const QString &page );
+
+Q_SIGNALS:
+    void assistantOpened();
+    void assistantClosed();
+    void error( const QString &msg );
+
+private Q_SLOTS:
+    void socketConnected();
+    void socketConnectionClosed();
+    void readPort();
+    void procError(QProcess::ProcessError err);
+    void socketError();
+    void readStdError();
+
+private:
+    QTcpSocket *socket;
+    QProcess *proc;
+    quint16 port;
+    QString host, assistantCommand, pageBuffer;
+    bool opened;
+};
+
+QT_END_NAMESPACE
+
+QT_END_HEADER
+
+#endif
diff -Naur qtiplot-0.9.8.9/3rdparty/qt-assistant-client/include/qassistantclient_global.h qtiplot-0.9.8.9.patch.ok/3rdparty/qt-assistant-client/include/qassistantclient_global.h
--- qtiplot-0.9.8.9/3rdparty/qt-assistant-client/include/qassistantclient_global.h	1970-01-01 01:00:00.000000000 +0100
+++ qtiplot-0.9.8.9.patch.ok/3rdparty/qt-assistant-client/include/qassistantclient_global.h	2014-09-11 23:52:45.000000000 +0200
@@ -0,0 +1,63 @@
+/****************************************************************************
+**
+** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
+** All rights reserved.
+** Contact: Nokia Corporation (qt-info@nokia.com)
+**
+** This file is part of the Qt Assistant of the Qt Toolkit.
+**
+** $QT_BEGIN_LICENSE:LGPL$
+** Commercial Usage
+** Licensees holding valid Qt Commercial licenses may use this file in
+** accordance with the Qt Commercial License Agreement provided with the
+** Software or, alternatively, in accordance with the terms contained in
+** a written agreement between you and Nokia.
+**
+** GNU Lesser General Public License Usage
+** Alternatively, this file may be used under the terms of the GNU Lesser
+** General Public License version 2.1 as published by the Free Software
+** Foundation and appearing in the file LICENSE.LGPL included in the
+** packaging of this file.  Please review the following information to
+** ensure the GNU Lesser General Public License version 2.1 requirements
+** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
+**
+** In addition, as a special exception, Nokia gives you certain additional
+** rights.  These rights are described in the Nokia Qt LGPL Exception
+** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
+**
+** GNU General Public License Usage
+** Alternatively, this file may be used under the terms of the GNU
+** General Public License version 3.0 as published by the Free Software
+** Foundation and appearing in the file LICENSE.GPL included in the
+** packaging of this file.  Please review the following information to
+** ensure the GNU General Public License version 3.0 requirements will be
+** met: http://www.gnu.org/copyleft/gpl.html.
+**
+** If you have questions regarding the use of this file, please contact
+** Nokia at qt-info@nokia.com.
+** $QT_END_LICENSE$
+**
+****************************************************************************/
+
+#ifndef QASSISTANTCLIENT_GLOBAL_H
+#define QASSISTANTCLIENT_GLOBAL_H
+
+#include <QtCore/qglobal.h>
+
+QT_BEGIN_HEADER
+
+QT_BEGIN_NAMESPACE
+
+#if defined(QT_ASSISTANT_CLIENT_STATIC) || (!defined(QT_SHARED) && !defined(QT_DLL))
+#  define QT_ASSISTANT_CLIENT_EXPORT
+#elif defined(QT_ASSISTANT_CLIENT_LIBRARY)
+#  define QT_ASSISTANT_CLIENT_EXPORT Q_DECL_EXPORT
+#else
+#  define QT_ASSISTANT_CLIENT_EXPORT Q_DECL_IMPORT
+#endif
+
+QT_END_NAMESPACE
+
+QT_END_HEADER
+
+#endif
diff -Naur qtiplot-0.9.8.9/3rdparty/qt-assistant-client/qt-assistant-client.pro qtiplot-0.9.8.9.patch.ok/3rdparty/qt-assistant-client/qt-assistant-client.pro
--- qtiplot-0.9.8.9/3rdparty/qt-assistant-client/qt-assistant-client.pro	1970-01-01 01:00:00.000000000 +0100
+++ qtiplot-0.9.8.9.patch.ok/3rdparty/qt-assistant-client/qt-assistant-client.pro	2014-09-11 23:52:45.000000000 +0200
@@ -0,0 +1,24 @@
+TEMPLATE        = lib
+QT += network
+TARGET                = QtAssistant
+
+isEmpty(QT_MAJOR_VERSION) {
+   VERSION=4.3.0
+} else {
+   VERSION=$${QT_MAJOR_VERSION}.$${QT_MINOR_VERSION}.$${QT_PATCH_VERSION}
+}
+
+INCLUDEPATH      = include
+DEPENDPATH       = include src
+
+CONFIG                += staticlib
+CONFIG                += qt warn_on
+CONFIG                += release
+
+HEADERS         = include/qassistantclient.h \
+                  include/qassistantclient_global.h
+SOURCES         = src/qassistantclient.cpp
+
+DESTDIR                = lib
+
+
diff -Naur qtiplot-0.9.8.9/3rdparty/qt-assistant-client/src/qassistantclient.cpp qtiplot-0.9.8.9.patch.ok/3rdparty/qt-assistant-client/src/qassistantclient.cpp
--- qtiplot-0.9.8.9/3rdparty/qt-assistant-client/src/qassistantclient.cpp	1970-01-01 01:00:00.000000000 +0100
+++ qtiplot-0.9.8.9.patch.ok/3rdparty/qt-assistant-client/src/qassistantclient.cpp	2014-09-11 23:52:45.000000000 +0200
@@ -0,0 +1,446 @@
+/****************************************************************************
+**
+** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
+** All rights reserved.
+** Contact: Nokia Corporation (qt-info@nokia.com)
+**
+** This file is part of the Qt Assistant of the Qt Toolkit.
+**
+** $QT_BEGIN_LICENSE:LGPL$
+** Commercial Usage
+** Licensees holding valid Qt Commercial licenses may use this file in
+** accordance with the Qt Commercial License Agreement provided with the
+** Software or, alternatively, in accordance with the terms contained in
+** a written agreement between you and Nokia.
+**
+** GNU Lesser General Public License Usage
+** Alternatively, this file may be used under the terms of the GNU Lesser
+** General Public License version 2.1 as published by the Free Software
+** Foundation and appearing in the file LICENSE.LGPL included in the
+** packaging of this file.  Please review the following information to
+** ensure the GNU Lesser General Public License version 2.1 requirements
+** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
+**
+** In addition, as a special exception, Nokia gives you certain additional
+** rights.  These rights are described in the Nokia Qt LGPL Exception
+** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
+**
+** GNU General Public License Usage
+** Alternatively, this file may be used under the terms of the GNU
+** General Public License version 3.0 as published by the Free Software
+** Foundation and appearing in the file LICENSE.GPL included in the
+** packaging of this file.  Please review the following information to
+** ensure the GNU General Public License version 3.0 requirements will be
+** met: http://www.gnu.org/copyleft/gpl.html.
+**
+** If you have questions regarding the use of this file, please contact
+** Nokia at qt-info@nokia.com.
+** $QT_END_LICENSE$
+**
+****************************************************************************/
+
+#include "qassistantclient.h"
+
+#include <qtcpsocket.h>
+#include <qtextstream.h>
+#include <qtimer.h>
+#include <qfileinfo.h>
+#include <qmap.h>
+
+QT_BEGIN_NAMESPACE
+
+class QAssistantClientPrivate
+{
+    friend class QAssistantClient;
+    QStringList arguments;
+};
+
+static QMap<const QAssistantClient*,QAssistantClientPrivate*> *dpointers = 0;
+
+static QAssistantClientPrivate *data( const QAssistantClient *client, bool create=false )
+{
+    if( !dpointers )
+        dpointers = new QMap<const QAssistantClient*,QAssistantClientPrivate*>;
+    QAssistantClientPrivate *d = (*dpointers)[client];
+    if( !d && create ) {
+        d = new QAssistantClientPrivate;
+        dpointers->insert( client, d );
+    }
+    return d;
+}
+
+/*!
+    \class QAssistantClient
+    \obsolete
+    \brief The QAssistantClient class provides a means of using Qt
+    Assistant as an application's help tool.
+
+    \ingroup helpsystem
+
+    \bold{Note:} \e{This class is obsolete and only required when using
+    the old Qt Assistant, now called assistant_adp. If you want to use
+    the new Qt Assistant as a remote help viewer, simple create a
+    QProcess instance and specify \tt{assistant} as its executable.
+    The following code shows how to start Qt Assistant and request a
+    certain page to be shown:}
+
+    \snippet doc/src/snippets/code/tools_assistant_compat_lib_qassistantclient.cpp 0
+    
+    \e{For a complete example using the Qt Assistant remotely, see the \l
+    {help/remotecontrol}{Remote Control} example.}
+    
+    In order to make Qt Assistant act as a customized help tool for
+    your application, you must provide your application with a
+    QAssistantClient object in addition to a \l
+    {assistant-manual.html} {Qt Assistant Document Profile} (\c .adp
+    file) and the associated documentation.
+
+    Note that the QAssistantClient class is not included in the Qt
+    library. To use it you must add the following line to your pro
+    file:
+
+    \snippet doc/src/snippets/code/tools_assistant_compat_lib_qassistantclient.cpp 1
+
+    A QAssistantClient instance can open or close Qt Assistant
+    whenever it is required.
+
+    Once you have created a QAssistantClient instance, specifying the
+    path to the Qt Assistant executable, using Qt Assistant is
+    simple: You can either call the openAssistant() slot to show the
+    defined start page of the documentation, or you can call the
+    showPage() slot to show a particular help page. When you call
+    openAssistant() and showPage(), Qt Assistant will be launched if
+    it isn't already running. When Qt Assistant is running, the
+    isOpen() function returns true.
+
+    When calling showPage() the Qt Assistant instance will also be
+    brought to the foreground if its hidden. The showPage() slot can
+    be called multiple times, while calling openAssistant() several
+    times without closing the application in between, will have no
+    effect.
+
+    You can close Qt Assistant at any time using the closeAssistant()
+    slot. When you call openAssistant(), or you call showPage()
+    without a previous call to openAssistant(), the assistantOpened()
+    signal is emitted. Similarly when closeAssistant() is called,
+    assistantClosed() is emitted. In either case, if an error occurs,
+    error() is emitted.
+
+    One QAssistantClient instance interacts with one Qt Assistant
+    instance, so every time you call openAssistant(), showPage() or
+    closeAssistant() they are applied to the particular Qt Assistant
+    instance associated with the QAssistantClient.
+
+    Qt Assistant's documentation set can be altered using the command
+    line arguments that are passed to the application when it is
+    launched. When started without any options, Qt Assistant displays
+    a default set of documentation. When Qt is installed, the default
+    documentation set in Qt Assistant contains the Qt reference
+    documentation as well as the tools that come with Qt, such as \QD
+    and \c qmake.
+
+    Use the setArguments() function to specify the command line
+    arguments. You can add or remove documentation from Qt Assistant
+    by adding and removing the relevant content files: The command
+    line arguments are \c {-addContentFile file.dcf} and \c
+    {-removeContentFile file.dcf} respectively. You can make Qt
+    Assistant run customized documentation sets that are separate from
+    the Qt documentation, by specifying a profile: \c {-profile
+    myapplication.adp}. The profile format can also be used to alter
+    several of Qt Assistant's properties such as its title and
+    startpage.
+
+    The Documentation Content File (\c .dcf) and Qt Assistant
+    Documentation Profile (\c .adp) formats are documented in the \l
+    {assistant-manual.html}{Qt Assistant Manual}.
+
+    For a complete example using the QAssistantClient class, see the
+    \e{Simple Text Viewer} example. The example shows how you can make
+    Qt Assistant act as a customized help tool for your application
+    using the QAssistantClient class combined with a Qt Assistant
+    Document Profile.
+
+    \sa {Qt Assistant Manual}, {Simple Text Viewer Example}
+*/
+
+/*!
+    \fn void QAssistantClient::assistantOpened()
+
+    This signal is emitted when Qt Assistant is opened and the
+    client-server communication is set up.
+
+    \sa openAssistant(), showPage()
+*/
+
+/*!
+    \fn void QAssistantClient::assistantClosed()
+
+    This signal is emitted when the connection to Qt Assistant is
+    closed. This happens when the user exits Qt Assistant, if an
+    error in the server or client occurs, or if closeAssistant() is
+    called.
+
+    \sa closeAssistant()
+*/
+
+/*!
+    \fn void QAssistantClient::error( const QString &message )
+
+    This signal is emitted if Qt Assistant cannot be started, or if an
+    error occurs during the initialization of the connection between
+    Qt Assistant and the calling application. The \a message provides an
+    explanation of the error.
+*/
+
+/*!
+  Constructs an assistant client with the specified \a parent. For
+  systems other than Mac OS, \a path specifies the path to the Qt
+  Assistant executable. For Mac OS, \a path specifies a directory
+  containing a valid assistant.app bundle. If \a path is the empty
+  string, the system path (\c{%PATH%} or \c $PATH) is used.
+*/
+QAssistantClient::QAssistantClient( const QString &path, QObject *parent )
+    : QObject( parent ), host ( QLatin1String("localhost") )
+{
+#if defined(Q_OS_MAC)
+    const QString assistant = QLatin1String("Assistant_adp");
+#else
+    const QString assistant = QLatin1String("assistant_adp");
+#endif
+
+    if ( path.isEmpty() )
+        assistantCommand = assistant;
+    else {
+        QFileInfo fi( path );
+        if ( fi.isDir() )
+            assistantCommand = path + QLatin1String("/") + assistant;
+        else
+            assistantCommand = path;
+    }
+
+#if defined(Q_OS_MAC)
+    assistantCommand += QLatin1String(".app/Contents/MacOS/Assistant_adp");
+#endif
+
+    socket = new QTcpSocket( this );
+    connect( socket, SIGNAL(connected()),
+            SLOT(socketConnected()) );
+    connect( socket, SIGNAL(disconnected()),
+            SLOT(socketConnectionClosed()) );
+    connect( socket, SIGNAL(error(QAbstractSocket::SocketError)),
+             SLOT(socketError()) );
+    opened = false;
+    proc = new QProcess( this );
+    port = 0;
+    pageBuffer = QLatin1String("");
+    connect( proc, SIGNAL(readyReadStandardError()),
+             this, SLOT(readStdError()) );
+    connect( proc, SIGNAL(error(QProcess::ProcessError)),
+        this, SLOT(procError(QProcess::ProcessError)) );
+}
+
+/*!
+    Destroys the assistant client object.
+*/
+QAssistantClient::~QAssistantClient()
+{
+    if ( proc->state() == QProcess::Running )
+        proc->terminate();
+
+    if( dpointers ) {
+        QAssistantClientPrivate *d = (*dpointers)[ this ];
+        if ( d ) {
+            dpointers->remove(this);
+            delete d;
+            if( dpointers->isEmpty() ) {
+                delete dpointers;
+                dpointers = 0;
+            }
+        }
+    }
+}
+
+/*!
+    Opens Qt Assistant, i.e. sets up the client-server communication
+    between the application and Qt Assistant, and shows the start page
+    specified by the current \l {assistant-manual.html}
+    {Qt Assistant Document Profile}. If there is no specfied profile,
+    and Qt is installed, the default start page is the Qt Reference
+    Documentation's index page.
+
+    If the connection is already established, this function does
+    nothing. Use the showPage() function to show another page. If an
+    error occurs, the error() signal is emitted.
+
+    \sa showPage(), assistantOpened()
+*/
+void QAssistantClient::openAssistant()
+{
+    if ( proc->state() == QProcess::Running )
+        return;
+
+    QStringList args;
+    args.append(QLatin1String("-server"));
+    if( !pageBuffer.isEmpty() ) {
+        args.append( QLatin1String("-file") );
+        args.append( pageBuffer );
+    }
+
+    QAssistantClientPrivate *d = data( this );
+    if( d ) {
+        QStringList::ConstIterator it = d->arguments.constBegin();
+        while( it!=d->arguments.constEnd() ) {
+            args.append( *it );
+            ++it;
+        }
+    }
+
+    connect( proc, SIGNAL(readyReadStandardOutput()),
+        this, SLOT(readPort()) );
+
+    proc->start(assistantCommand, args);
+}
+
+void QAssistantClient::procError(QProcess::ProcessError err)
+{
+    switch (err)
+    {
+    case QProcess::FailedToStart:
+        emit error( tr( "Failed to start Qt Assistant." ) );
+        break;
+    case QProcess::Crashed:
+        emit error( tr( "Qt Assistant crashed." ) );
+        break;
+    default:
+        emit error( tr( "Error while running Qt Assistant." ) );
+    }
+}
+
+void QAssistantClient::readPort()
+{
+    QString p(QString::fromLatin1(proc->readAllStandardOutput()));
+    quint16 port = p.toUShort();
+    if ( port == 0 ) {
+        emit error( tr( "Cannot connect to Qt Assistant." ) );
+        return;
+    }
+    socket->connectToHost( host, port );
+    disconnect( proc, SIGNAL(readyReadStandardOutput()),
+                this, SLOT(readPort()) );
+}
+
+/*!
+    Closes the Qt Assistant instance.
+
+    \sa openAssistant(), assistantClosed()
+*/
+void QAssistantClient::closeAssistant()
+{
+    if ( !opened )
+        return;
+
+    bool blocked = proc->blockSignals(true);
+    proc->terminate();
+    if (!proc->waitForFinished(2000)) {
+        // If the process hasn't died after 2 seconds,
+        // we kill it, causing it to exit immediately.
+        proc->kill();
+    }
+    proc->blockSignals(blocked);
+}
+
+/*!
+    Brings Qt Assistant to the foreground showing the given \a page.
+    The \a page parameter is a path to an HTML file
+    (e.g., QLatin1String("/home/pasquale/superproduct/docs/html/intro.html")).
+
+    If Qt Assistant hasn't been opened yet, this function will call
+    the openAssistant() slot with the specified page as the start
+    page.
+
+    \note The first time Qt Assistant is started, its window will open
+    in front of the application's windows. Subsequent calls to this function
+    will only load the specified pages in Qt Assistant and will not display
+    its window in front of the application's windows.
+
+    \sa openAssistant()
+*/
+void QAssistantClient::showPage( const QString &page )
+{
+    if (opened) {
+        QTextStream os( socket );
+        os << page << QLatin1String("\n");
+    } else {
+        pageBuffer = page;
+
+        if (proc->state() == QProcess::NotRunning) {
+            openAssistant();
+            pageBuffer.clear();
+            return;
+        }
+    }
+}
+
+/*!
+    \property QAssistantClient::open
+    \brief whether Qt Assistant is open
+
+*/
+bool QAssistantClient::isOpen() const
+{
+    return opened;
+}
+
+void QAssistantClient::socketConnected()
+{
+    opened = true;
+    if ( !pageBuffer.isEmpty() )
+        showPage( pageBuffer );
+    emit assistantOpened();
+}
+
+void QAssistantClient::socketConnectionClosed()
+{
+    opened = false;
+    emit assistantClosed();
+}
+
+void QAssistantClient::socketError()
+{
+    QAbstractSocket::SocketError err = socket->error();
+    if (err == QTcpSocket::ConnectionRefusedError)
+        emit error( tr( "Could not connect to Assistant: Connection refused" ) );
+    else if (err == QTcpSocket::HostNotFoundError)
+        emit error( tr( "Could not connect to Assistant: Host not found" ) );
+    else if (err != QTcpSocket::RemoteHostClosedError)
+        emit error( tr( "Communication error" ) );
+}
+
+void QAssistantClient::readStdError()
+{
+    QString errmsg = QString::fromLatin1(proc->readAllStandardError());
+
+    if (!errmsg.isEmpty())
+        emit error( errmsg.simplified() );
+}
+
+/*!
+    \fn void QAssistantClient::setArguments(const QStringList &arguments)
+
+    Sets the command line \a arguments that are passed to Qt Assistant
+    when it is launched.
+
+    The command line arguments can be used to alter Qt Assistant's
+    documentation set. When started without any options, Qt Assistant
+    displays a default set of documentation. When Qt is installed, the
+    default documentation set in Qt Assistant contains the Qt
+    reference documentation as well as the tools that come with Qt,
+    such as Qt Designer and qmake.
+*/
+void QAssistantClient::setArguments( const QStringList &args )
+{
+    QAssistantClientPrivate *d = data( this, true );
+    d->arguments = args;
+}
+
+QT_END_NAMESPACE
diff -Naur qtiplot-0.9.8.9/3rdparty/qwt/src/src.pro qtiplot-0.9.8.9.patch.ok/3rdparty/qwt/src/src.pro
--- qtiplot-0.9.8.9/3rdparty/qwt/src/src.pro	2010-10-07 17:17:13.000000000 +0200
+++ qtiplot-0.9.8.9.patch.ok/3rdparty/qwt/src/src.pro	2014-09-12 00:41:47.000000000 +0200
@@ -221,4 +221,4 @@
     doc.files      += $${QWT_ROOT}/doc/man
 }
 
-INSTALLS       = target headers doc
+#INSTALLS       = target headers doc
diff -Naur qtiplot-0.9.8.9/3rdparty/qwtplot3d/3rdparty/gl2ps/gl2ps.c qtiplot-0.9.8.9.patch.ok/3rdparty/qwtplot3d/3rdparty/gl2ps/gl2ps.c
--- qtiplot-0.9.8.9/3rdparty/qwtplot3d/3rdparty/gl2ps/gl2ps.c	2011-08-23 11:57:54.000000000 +0200
+++ qtiplot-0.9.8.9.patch.ok/3rdparty/qwtplot3d/3rdparty/gl2ps/gl2ps.c	2014-09-11 23:52:45.000000000 +0200
@@ -42,13 +42,10 @@
 #include <time.h>
 #include <float.h>
 
-#if defined(GL2PS_HAVE_ZLIB)
 #include <zlib.h>
-#endif
 
-#if defined(GL2PS_HAVE_LIBPNG)
 #include <png.h>
-#endif
+
 
 /*********************************************************************
  *
diff -Naur qtiplot-0.9.8.9/3rdparty/qwtplot3d/include/qwt3d_openglhelper.h qtiplot-0.9.8.9.patch.ok/3rdparty/qwtplot3d/include/qwt3d_openglhelper.h
--- qtiplot-0.9.8.9/3rdparty/qwtplot3d/include/qwt3d_openglhelper.h	2011-08-24 12:25:09.000000000 +0200
+++ qtiplot-0.9.8.9.patch.ok/3rdparty/qwtplot3d/include/qwt3d_openglhelper.h	2014-09-11 23:52:45.000000000 +0200
@@ -1,6 +1,6 @@
 #ifndef __openglhelper_2003_06_06_15_49__
 #define __openglhelper_2003_06_06_15_49__
-
+#include <glu.h>
 #include "qglobal.h"
 #if QT_VERSION < 0x040000
 #include <qgl.h>
diff -Naur qtiplot-0.9.8.9/3rdparty/qwtplot3d/qwtplot3d.pro qtiplot-0.9.8.9.patch.ok/3rdparty/qwtplot3d/qwtplot3d.pro
--- qtiplot-0.9.8.9/3rdparty/qwtplot3d/qwtplot3d.pro	2011-08-24 16:54:38.000000000 +0200
+++ qtiplot-0.9.8.9.patch.ok/3rdparty/qwtplot3d/qwtplot3d.pro	2014-09-12 00:42:09.000000000 +0200
@@ -36,5 +36,5 @@
 LIBS        += ../libpng/libpng.a
 
 # install
-target.path = lib
-INSTALLS += target
+#target.path = lib
+#INSTALLS += target
diff -Naur qtiplot-0.9.8.9/build.conf qtiplot-0.9.8.9.patch.ok/build.conf
--- qtiplot-0.9.8.9/build.conf	1970-01-01 01:00:00.000000000 +0100
+++ qtiplot-0.9.8.9.patch.ok/build.conf	2014-09-12 00:09:28.000000000 +0200
@@ -0,0 +1,173 @@
+isEmpty( QTI_ROOT ) {
+  message( "each file including this config needs to set QTI_ROOT to the dir containing this file!" )
+}
+
+##########################################################
+##     System specific configuration
+##########################################################
+
+# Global include path which is always added at the end of the INCLUDEPATH
+SYS_INCLUDEPATH = /usr/local/include
+# Global lib path and libs which is ls always added at the end of LIBS
+SYS_LIBS = -L/usr/local/lib
+
+##########################################################
+## zlib (http://www.zlib.net/)
+##########################################################
+
+# include path. leave it blank to use SYS_INCLUDE
+#ZLIB_INCLUDEPATH = $$QTI_ROOT/3rdparty/zlib/
+
+##########################################################
+## muParser (http://muparser.sourceforge.net/)
+##########################################################
+
+# include path. leave it blank to use SYS_INCLUDE
+#MUPARSER_INCLUDEPATH = $$QTI_ROOT/3rdparty/muparser_v2_2_3/include
+# link statically against a copy in 3rdparty/
+MUPARSER_LIBS = $$QTI_ROOT/3rdparty/muparser_v2_2_3/lib/libmuparser.a
+# or dynamically against a system-wide installation
+MUPARSER_LIBS = -lmuparser
+
+##########################################################
+## GNU Sientific Library (http://www.gnu.org/software/gsl/)
+##########################################################
+
+# include path. leave it blank to use SYS_INCLUDE
+#GSL_INCLUDEPATH = $$QTI_ROOT/3rdparty/gsl/include
+# link statically against a copy in 3rdparty/
+#GSL_LIBS = $$QTI_ROOT/3rdparty/gsl/lib/libgsl.a \
+#           $$QTI_ROOT/3rdparty/gsl/lib/libgslcblas.a
+# or dynamically against a system-wide installation
+GSL_LIBS = -lgsl -lgslcblas
+
+##########################################################
+## QWT - use local copy till upstream catches up
+# http://qwt.sourceforge.net/index.html
+##########################################################
+
+# include path.
+QWT_INCLUDEPATH = $$QTI_ROOT/3rdparty/qwt/src
+# link locally against a copy in 3rdparty/
+QWT_LIBS = $$QTI_ROOT/3rdparty/qwt/lib/libqwt.a
+
+##########################################################
+## QwtPlot3D - use local copy till upstream catches up
+# http://qwtplot3d.sourceforge.net/
+##########################################################
+
+# include path.
+QWT3D_INCLUDEPATH = $$QTI_ROOT/3rdparty/qwtplot3d/include
+# link locally against a copy in 3rdparty/
+#win32:QWT3D_LIBS = $$QTI_ROOT/3rdparty/qwtplot3d/lib/qwtplot3d.dll
+unix:QWT3D_LIBS = $$QTI_ROOT/3rdparty/qwtplot3d/lib/libqwtplot3d.a
+#QWT3D_LIBS = -lqwtplot3d
+
+##########################################################
+## libpng - optional. you don't have to set these variables
+##########################################################
+
+# include path. leave it blank to use SYS_INCLUDE
+#LIBPNG_INCLUDEPATH = $$QTI_ROOT/3rdparty/libpng/include
+# link statically against a copy in 3rdparty/
+#LIBPNG_LIBS = $$QTI_ROOT/3rdparty/libpng/lib/libpng.a
+# or dynamically against a system-wide installation
+LIBPNG_LIBS = -lpng
+
+##########################################################
+## QTeXEngine - optional. you don't have to set these variables
+# http://soft.proindependent.com/qtexengine/
+##########################################################
+
+# include path.
+#TEX_ENGINE_INCLUDEPATH = $$QTI_ROOT/3rdparty/QTeXEngine/src
+# link locally against a copy in 3rdparty/
+#TEX_ENGINE_LIBS = $$QTI_ROOT/3rdparty/QTeXEngine/libQTeXEngine.a
+
+##########################################################
+## ALGLIB (2.6) - optional. you don't have to set these variables
+# http://www.alglib.net/
+##########################################################
+
+# include path.
+ALGLIB_INCLUDEPATH = $$SYS_INCLUDEPATH/alglib/
+# link locally against a copy in 3rdparty/
+#ALGLIB_LIBS = $$QTI_ROOT/3rdparty/alglib/libalglib.a
+ALGLIB_LIBS = -lalglib
+
+##########################################################
+## TAMUANOVA - optional. you don't have to set these variables
+# http://www.stat.tamu.edu/~aredd/tamuanova/
+##########################################################
+
+# include path.
+#TAMUANOVA_INCLUDEPATH = $$QTI_ROOT/3rdparty/tamu_anova-0.2/
+# link locally against a copy in 3rdparty/
+#TAMUANOVA_LIBS = $$QTI_ROOT/3rdparty/tamu_anova-0.2/libtamuanova.a
+
+TAMUANOVA_LIBS = -ltamuanova
+
+##########################################################
+## liborigin2 - optional. you don't have to set these variables
+# http://soft.proindependent.com/liborigin2/
+##########################################################
+
+# include path. leave it blank to use SYS_INCLUDE
+#LIBORIGIN_INCLUDEPATH = $$QTI_ROOT/3rdparty/liborigin2
+# link statically against a copy in 3rdparty/
+#LIBORIGIN_LIBS = $$QTI_ROOT/3rdparty/liborigin2/liborigin2.a
+
+LIBORIGIN_LIBS = -lorigin2
+
+##########################################################
+## QtAssistant Framework
+##########################################################
+
+# include path. leave it blank to use SYS_INCLUDE
+LIBQTASSISTANT_INCLUDEPATH = $$QTI_ROOT/3rdparty/qt-assistant-client/include
+# link statically against a copy in 3rdparty/
+LIBQTASSISTANT_LIBS = $$QTI_ROOT/3rdparty/qt-assistant-client/lib/libQtAssistant.a
+
+##########################################################
+## python - only used if python is needed
+##########################################################
+
+# the python interpreter to use
+# (unix only, windows will use what ever is configured to execute .py files!)
+PYTHON = python
+
+##########################################################
+## Qt tools - allows to use specific versions
+##########################################################
+
+LUPDATE = lupdate
+LRELEASE = lrelease
+
+############################################################
+##  Target specific configuration: configure Qtiplot itself
+############################################################
+
+contains( TARGET, qtiplot ) {
+  # building without muParser doesn't work yet
+  SCRIPTING_LANGS += muParser
+#  SCRIPTING_LANGS += Python
+
+  # a console displaying output of scripts; particularly useful on Windows
+  # where running QtiPlot from a terminal is inconvenient
+  DEFINES         += SCRIPTING_CONSOLE
+
+  #DEFINES         += QTIPLOT_DEMO
+
+  # Uncomment the following line if you want to perform a custom installation using the *.path variables defined in ./qtiplot.pro.
+  #CONFIG          += CustomInstall
+
+  # Uncomment the following line if you want to build QtiPlot as a browser plugin (not working on Internet Explorer).
+  #CONFIG          += BrowserPlugin
+  
+  CONFIG          += release
+  #CONFIG          += debug
+  
+  # Uncomment the following line if you want to link statically against Qt.
+  #CONFIG           += StaticBuild
+  #win32: CONFIG   += console
+}
diff -Naur qtiplot-0.9.8.9/fitPlugins/exp_saturation/exp_saturation.pro qtiplot-0.9.8.9.patch.ok/fitPlugins/exp_saturation/exp_saturation.pro
--- qtiplot-0.9.8.9/fitPlugins/exp_saturation/exp_saturation.pro	2009-08-14 13:27:08.000000000 +0200
+++ qtiplot-0.9.8.9.patch.ok/fitPlugins/exp_saturation/exp_saturation.pro	2014-09-12 00:52:42.000000000 +0200
@@ -19,7 +19,7 @@
 INCLUDEPATH += $$GSL_INCLUDEPATH
 LIBS        += $$GSL_LIBS
 
-target.path=/usr/lib$${libsuff}/qtiplot/plugins
+target.path=$$PREFIX/lib/qtiplot/plugins
 INSTALLS += target
 
 SOURCES += exp_saturation.c
diff -Naur qtiplot-0.9.8.9/fitPlugins/explin/explin.pro qtiplot-0.9.8.9.patch.ok/fitPlugins/explin/explin.pro
--- qtiplot-0.9.8.9/fitPlugins/explin/explin.pro	2009-08-13 23:27:00.000000000 +0200
+++ qtiplot-0.9.8.9.patch.ok/fitPlugins/explin/explin.pro	2014-09-12 00:53:02.000000000 +0200
@@ -19,7 +19,7 @@
 INCLUDEPATH += $$GSL_INCLUDEPATH
 LIBS        += $$GSL_LIBS
 
-target.path=/usr/lib$${libsuff}/qtiplot/plugins
+target.path=$$PREFIX/lib/qtiplot/plugins
 INSTALLS += target
 
 SOURCES += explin.c
diff -Naur qtiplot-0.9.8.9/fitPlugins/fitRational0/fitRational0.pro qtiplot-0.9.8.9.patch.ok/fitPlugins/fitRational0/fitRational0.pro
--- qtiplot-0.9.8.9/fitPlugins/fitRational0/fitRational0.pro	2009-08-13 23:27:00.000000000 +0200
+++ qtiplot-0.9.8.9.patch.ok/fitPlugins/fitRational0/fitRational0.pro	2014-09-12 00:53:20.000000000 +0200
@@ -19,7 +19,7 @@
 INCLUDEPATH += $$GSL_INCLUDEPATH
 LIBS        += $$GSL_LIBS
 
-target.path=/usr/lib$${libsuff}/qtiplot/plugins
+target.path=$$PREFIX/lib/qtiplot/plugins
 INSTALLS += target
 
 SOURCES += fitRational0.cpp
diff -Naur qtiplot-0.9.8.9/fitPlugins/fitRational1/fitRational1.pro qtiplot-0.9.8.9.patch.ok/fitPlugins/fitRational1/fitRational1.pro
--- qtiplot-0.9.8.9/fitPlugins/fitRational1/fitRational1.pro	2009-08-13 23:27:00.000000000 +0200
+++ qtiplot-0.9.8.9.patch.ok/fitPlugins/fitRational1/fitRational1.pro	2014-09-12 00:52:00.000000000 +0200
@@ -19,7 +19,7 @@
 INCLUDEPATH += $$GSL_INCLUDEPATH
 LIBS        += $$GSL_LIBS
 
-target.path=/usr/lib$${libsuff}/qtiplot/plugins
+target.path=$$PREFIX/lib/qtiplot/plugins
 INSTALLS += target
 
 SOURCES += fitRational1.cpp
diff -Naur qtiplot-0.9.8.9/fitPlugins/planck_wavelength/planck_wavelength.pro qtiplot-0.9.8.9.patch.ok/fitPlugins/planck_wavelength/planck_wavelength.pro
--- qtiplot-0.9.8.9/fitPlugins/planck_wavelength/planck_wavelength.pro	2009-08-13 23:27:00.000000000 +0200
+++ qtiplot-0.9.8.9.patch.ok/fitPlugins/planck_wavelength/planck_wavelength.pro	2014-09-12 00:52:27.000000000 +0200
@@ -13,12 +13,12 @@
 CONFIG += release
 DESTDIR = ../
 
-INSTALLS += target
+#INSTALLS += target
  
 INCLUDEPATH += $$GSL_INCLUDEPATH
 LIBS        += $$GSL_LIBS
 
-target.path=/usr/lib$${libsuff}/qtiplot/plugins
+target.path=$$PREFIX/lib/qtiplot/plugins
 
 SOURCES = planck_wavelength.c
 
diff -Naur qtiplot-0.9.8.9/qtiplot/qtiplot.pro qtiplot-0.9.8.9.patch.ok/qtiplot/qtiplot.pro
--- qtiplot-0.9.8.9/qtiplot/qtiplot.pro	2011-11-02 17:55:25.000000000 +0100
+++ qtiplot-0.9.8.9.patch.ok/qtiplot/qtiplot.pro	2014-09-12 01:06:39.000000000 +0200
@@ -14,12 +14,16 @@
 INCLUDEPATH       += $$QWT_INCLUDEPATH
 INCLUDEPATH       += $$QWT3D_INCLUDEPATH
 INCLUDEPATH       += $$GSL_INCLUDEPATH
+INCLUDEPATH       += $$LIBQTASSISTANT_INCLUDEPATH
 
 # configurable libs
 LIBS         += $$MUPARSER_LIBS
 LIBS         += $$QWT_LIBS
 LIBS         += $$QWT3D_LIBS
 LIBS         += $$GSL_LIBS
+LIBS         += $$LIBQTASSISTANT_LIBS
+LIBS         += -lz
+
 
 #############################################################################
 ###################### BASIC PROJECT PROPERTIES #############################
@@ -35,41 +39,28 @@
 
 CONFIG        += qt warn_on exceptions opengl thread
 CONFIG        += assistant
-win32:CONFIG  += qaxcontainer
 
 DEFINES       += QT_PLUGIN
-contains(CONFIG, CustomInstall){
-	INSTALLS        += target
-	INSTALLS        += translations
-	INSTALLS        += manual
-	INSTALLS        += documentation
-	unix:INSTALLS        += man
-
-	unix: INSTALLBASE = /usr
-	win32: INSTALLBASE = C:/QtiPlot
-
-	unix: target.path = $$INSTALLBASE/bin
-	unix: translations.path = $$INSTALLBASE/share/qtiplot/translations
-	unix: manual.path = $$INSTALLBASE/share/doc/qtiplot/manual
-	unix: documentation.path = $$INSTALLBASE/share/doc/qtiplot
-	unix: man.path = $$INSTALLBASE/share/man/man1/
-
-	win32: target.path = $$INSTALLBASE
-	win32: translations.path = $$INSTALLBASE/translations
-	win32: manual.path = $$INSTALLBASE/manual
-	win32: documentation.path = $$INSTALLBASE/doc
-
-	DEFINES       += TRANSLATIONS_PATH="\\\"$$replace(translations.path," ","\ ")\\\"
-	DEFINES       += MANUAL_PATH="\\\"$$replace(manual.path," ","\ ")\\\"
-	}
+INSTALLS        += target
+INSTALLS        += translations
+INSTALLS        += manual
+INSTALLS        += documentation
+INSTALLS        += man
+
+INSTALLBASE = $$PREFIX
+
+
+target.path = $$INSTALLBASE/bin
+translations.path = $$INSTALLBASE/share/qtiplot/translations
+manual.path = $$INSTALLBASE/share/doc/qtiplot/manual
+documentation.path = $$INSTALLBASE/share/doc/qtiplot
+man.path = $$INSTALLBASE/share/man/man1/
+
+
+DEFINES       += TRANSLATIONS_PATH="\\\"$$replace(translations.path," ","\ ")\\\"
+DEFINES       += MANUAL_PATH="\\\"$$replace(manual.path," ","\ ")\\\"
 
 QT            += opengl qt3support network svg xml
-contains(CONFIG, StaticBuild){
-	QTPLUGIN += qjpeg qgif qtiff qmng qsvg
-	DEFINES += QTIPLOT_STATIC_BUILD
-} else {
-	win32:DEFINES += QT_DLL QT_THREAD_SUPPORT
-}
 
 MOC_DIR        = ../tmp/qtiplot
 OBJECTS_DIR    = ../tmp/qtiplot
@@ -120,13 +111,12 @@
 
 ###################### DOCUMENTATION ########################################
 
-manual.files += ../manual/html \
-                ../manual/qtiplot-manual-en.pdf
+manual.files += ../manual/html
 
 documentation.files += ../README.html \
                        ../gpl_licence.txt
 
-unix: man.files += ../qtiplot.1
+man.files += ../qtiplot.1
 
 ###############################################################
 ##################### Compression (zlib-1.2.3) ################
diff -Naur qtiplot-0.9.8.9/qtiplot/src/core/ApplicationWindow.cpp qtiplot-0.9.8.9.patch.ok/qtiplot/src/core/ApplicationWindow.cpp
--- qtiplot-0.9.8.9/qtiplot/src/core/ApplicationWindow.cpp	2011-11-01 13:21:13.000000000 +0100
+++ qtiplot-0.9.8.9.patch.ok/qtiplot/src/core/ApplicationWindow.cpp	2014-09-12 00:06:14.000000000 +0200
@@ -174,7 +174,7 @@
 #include <QVarLengthArray>
 #include <QList>
 #include <QUrl>
-#include <QAssistantClient>
+#include <QtAssistant>
 #include <QFontComboBox>
 #include <QSpinBox>
 #include <QMdiArea>
@@ -16228,11 +16228,12 @@
 	if (hostInfo.error() != QHostInfo::NoError){
 		QApplication::restoreOverrideCursor();
 		QMessageBox::critical(this, tr("QtiPlot - Error"), qtiplotWeb + ": " + hostInfo.errorString());
-		exit(0);
+		QApplication::restoreOverrideCursor();
+	}
+	else {
+		QApplication::restoreOverrideCursor();
+		showDonationsPage();
 	}
-
-	QApplication::restoreOverrideCursor();
-	showDonationsPage();
 }
 
 void ApplicationWindow::parseCommandLineArguments(const QStringList& args)
@@ -18856,7 +18857,7 @@
 	words.append("cell");
 #ifdef SCRIPTING_PYTHON
 	if (scriptEnv->name() == QString("Python")){
-		QString fn = d_python_config_folder + "/qti_wordlist.txt";
+		QString fn = "/usr/share/qtiplot/qti_wordlist.txt";
 		QFile file(fn);
 		if (!file.open(QFile::ReadOnly)){
 			QMessageBox::critical(this, tr("QtiPlot - Warning"),
diff -Naur qtiplot-0.9.8.9/qtiplot/src/core/QtiPlotApplication.cpp qtiplot-0.9.8.9.patch.ok/qtiplot/src/core/QtiPlotApplication.cpp
--- qtiplot-0.9.8.9/qtiplot/src/core/QtiPlotApplication.cpp	2011-10-25 11:56:27.000000000 +0200
+++ qtiplot-0.9.8.9.patch.ok/qtiplot/src/core/QtiPlotApplication.cpp	2014-09-12 00:06:27.000000000 +0200
@@ -59,9 +59,6 @@
 
 		ApplicationWindow *mw = new ApplicationWindow(factorySettings);
 		mw->restoreApplicationGeometry();
-	#if (!defined(QTIPLOT_PRO) && !defined(QTIPLOT_DEMO) && !defined(Q_WS_X11))
-		mw->showDonationDialog();
-	#endif
 		if (mw->autoSearchUpdates){
 			mw->autoSearchUpdatesRequest = true;
 			mw->searchForUpdates();
@@ -190,9 +187,7 @@
 		return;
 
 	mw->restoreApplicationGeometry();
-#if (!defined(QTIPLOT_PRO) && !defined(QTIPLOT_DEMO) && !defined(Q_WS_X11))
-	mw->showDonationDialog();
-#endif
+
 	mw->initWindow();
 
 	updateDockMenu();
diff -Naur qtiplot-0.9.8.9/qtiplot/src/table/Table.cpp qtiplot-0.9.8.9.patch.ok/qtiplot/src/table/Table.cpp
--- qtiplot-0.9.8.9/qtiplot/src/table/Table.cpp	2011-09-13 13:20:29.000000000 +0200
+++ qtiplot-0.9.8.9.patch.ok/qtiplot/src/table/Table.cpp	2014-09-12 18:41:08.000000000 +0200
@@ -564,7 +564,7 @@
 	QApplication::setOverrideCursor(QCursor(Qt::WaitCursor));
 
     muParserScript *mup = new muParserScript(scriptEnv, cmd, this,  QString("<%1>").arg(colName(col)));
-    double *r = mup->defineVariable("i");
+    double *r = mup->defineVariable("i",startRow + 1.0);
     mup->defineVariable("j", (double)col);
     mup->defineVariable("sr", startRow + 1.0);
     mup->defineVariable("er", endRow + 1.0);
diff -Naur qtiplot-0.9.8.9/qtiplot.pro qtiplot-0.9.8.9.patch.ok/qtiplot.pro
--- qtiplot-0.9.8.9/qtiplot.pro	2010-09-20 19:08:10.000000000 +0200
+++ qtiplot-0.9.8.9.patch.ok/qtiplot.pro	2014-09-12 00:33:15.000000000 +0200
@@ -1,7 +1,7 @@
 TEMPLATE = subdirs
-
+CONFIG += CustomInstall
 SUBDIRS = fitPlugins \
-	    manual \
 	    3rdparty/qwt \
 		3rdparty/qwtplot3d \
+		3rdparty/qt-assistant-client \
         qtiplot
