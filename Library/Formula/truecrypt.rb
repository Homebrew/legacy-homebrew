require 'formula'

class Truecrypt < Formula
  homepage 'http://truecrypt.org/'
  url 'ftp://ftp.archlinux.org/other/tc/truecrypt-7.1a.tar.gz'
  sha256 'e6214e911d0bbededba274a2f8f8d7b3f6f6951e20f1c3a598fc7a23af81c8dc'

  # RSA PKCS #11 Cryptographic Token Interface (Cryptoki)
  # Original files packed in tarball downloaded from ARCH linux mirror,
  # originally resides as bare files at: ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-11/v2-20/
  resource 'Pkcs' do
    url 'ftp://ftp.archlinux.org/other/tc/pkcs-2.20.tar.gz'
    sha256 'd2bf64094eec48b4695a15d91c05fe4469485a5cc6b0efc0ee75a20c095bd40d'
  end

  conflicts_with 'fuse4x'

  depends_on 'pkg-config' => :build
  depends_on 'nasm' => :build
  depends_on 'wxmac'
  depends_on 'osxfuse'

  # since upstream do not provide issues/code tracking,
  # changes were reported upstream using following form:
  # http://www.truecrypt.org/contact-forms/msg?t=1001
  def patches
    # Reflect changes in wxmac
    patches = {
      :p1 => DATA,
    }
  end

  def install
    (buildpath/'Pkcs').install resource('Pkcs')
    ENV['PKCS11_INC'] = buildpath/'Pkcs'

    # generic osx adaptations
    inreplace "Makefile", "TC_OSX_SDK ?= /Developer/SDKs/MacOSX10.4u.sdk", "AS := nasm"
    inreplace "Makefile", "CC := gcc-4.0", "CC := gcc"
    inreplace "Makefile", "CXX := g++-4.0", "CXX := g++"
    inreplace "Makefile", "C_CXX_FLAGS += -DTC_UNIX -DTC_BSD -DTC_MACOSX -mmacosx-version-min=10.4 -isysroot $(TC_OSX_SDK)", "C_CXX_FLAGS += -D_XOPEN_SOURCE -DTC_UNIX -DTC_BSD -DTC_MACOSX -I#{buildpath}/Pkcs"
    inreplace "Makefile", "\tLFLAGS += -mmacosx-version-min=10.4 -Wl,-syslibroot $(TC_OSX_SDK)\n", ""
    inreplace "Makefile", "\tWX_CONFIGURE_FLAGS += --with-macosx-version-min=10.4 --with-macosx-sdk=$(TC_OSX_SDK)\n", ""
    inreplace "Main/FatalErrorHandler.cpp", "include <i386/ucontext.h>", "include <sys/ucontext.h>"
    inreplace "Main/FatalErrorHandler.cpp", "context->uc_mcontext->ss.", "context->uc_mcontext->__ss.__"
    inreplace "Main/Main.make", "WX_CONFIG_LIBS := base\n", "WX_CONFIG_LIBS := base,core\n"

    # fix 64-bit support
    inreplace "Makefile", "ARCH = $(shell uname -p)", "ARCH = $(shell uname -m)"
    inreplace "Makefile", "\tASM_OBJ_FORMAT = macho\n", ""
    inreplace "Makefile", "\t\tCPU_ARCH = x86", "\t\tASM_OBJ_FORMAT = macho64"
    inreplace "Makefile", " -arch i386 -arch ppc", ""

    # replace fuse with osxfuse
    inreplace "Main/Main.make", "FUSE_LIBS = $(shell pkg-config fuse --libs)", "FUSE_LIBS = $(shell pkg-config osxfuse --libs)"
    inreplace "Driver/Fuse/Driver.make", "CXXFLAGS += $(shell pkg-config fuse --cflags)", "CXXFLAGS += $(shell pkg-config osxfuse --cflags) -D_FILE_OFFSET_BITS=64 -D_DARWIN_USE_64_BIT_INODE"
    inreplace "Core/Unix/MacOSX/CoreMacOSX.cpp", "macfuse.version.number", "osxfuse.version.number"

    # fix non 512b sector size
    inreplace "Core/VolumeCreator.cpp", "#if !defined (TC_LINUX)", "#if !defined (TC_LINUX) && !defined (TC_MACOSX)"
    inreplace "Volume/EncryptionThreadPool.cpp", "fragmentData += unitsPerFragment * ENCRYPTION_DATA_UNIT_SIZE;", "fragmentData += unitsPerFragment * sectorSize;"
    inreplace "Volume/VolumeHeader.cpp", "#if !(defined (TC_WINDOWS) || defined (TC_LINUX))", "#if !(defined (TC_WINDOWS) || defined (TC_LINUX) || defined (TC_MACOSX))"

    # build and install gui version
    system "make"
    prefix.install 'Main/TrueCrypt.app'

    # build and install command line version
    system 'make clean'
    system 'make', 'NOGUI=1'
    bin.install 'Main/TrueCrypt' => "truecrypt"
  end

  def test
    system "#{bin}/truecrypt --test"
  end
end

__END__

diff -ur a/Main/Application.cpp b/Main/Application.cpp
--- a/Main/Application.cpp
+++ b/Main/Application.cpp
@@ -36,7 +36,6 @@
 
 	FilePath Application::GetConfigFilePath (const wxString &configFileName, bool createConfigDir)
 	{
-		wxStandardPaths stdPaths;
 		DirectoryPath configDir;
 		
 		if (!Core->IsInPortableMode())
@@ -46,6 +45,7 @@
 			configPath.Normalize();
 			configDir = wstring (configPath.GetFullPath());
 #else
+			wxStandardPaths stdPaths;
 			configDir = wstring (stdPaths.GetUserDataDir());
 #endif
 		}
@@ -61,12 +61,12 @@
 
 	DirectoryPath Application::GetExecutableDirectory ()
 	{
-		return wstring (wxFileName (wxStandardPaths().GetExecutablePath()).GetPath());
+		return wstring (wxFileName (wxStandardPaths::Get().GetExecutablePath()).GetPath());
 	}
 
 	FilePath Application::GetExecutablePath ()
 	{
-		return wstring (wxStandardPaths().GetExecutablePath());
+		return wstring (wxStandardPaths::Get().GetExecutablePath());
 	}
 
 	void Application::Initialize (UserInterfaceType::Enum type)
diff -ur a/Main/CommandLineInterface.cpp b/Main/CommandLineInterface.cpp
--- a/Main/CommandLineInterface.cpp
+++ b/Main/CommandLineInterface.cpp
@@ -380,7 +380,7 @@
 		ArgQuick = parser.Found (L"quick");
 
 		if (parser.Found (L"random-source", &str))
-			ArgRandomSourcePath = FilesystemPath (str);
+			ArgRandomSourcePath = FilesystemPath (str.wc_str());
 
 		if (parser.Found (L"restore-headers"))
 		{
@@ -471,7 +471,7 @@
 
 			if (param1IsFile)
 			{
-				ArgFilePath.reset (new FilePath (parser.GetParam (0)));
+				ArgFilePath.reset (new FilePath (parser.GetParam (0).wc_str()));
 			}
 		}
 
@@ -524,7 +524,7 @@
 					arr.Add (L"");
 					continue;
 				}
-				arr.Last() += token.empty() ? L',' : token;
+				arr.Last() += token.empty() ? wxString(L',') : token;
 			}
 			else
 				arr.Add (token);
@@ -562,12 +562,12 @@
 			{
 				filteredVolumes.push_back (volume);
 			}
-			else if (wxString (volume->Path) == pathFilter.GetFullPath())
+			else if (wxString (wstring(volume->Path)) == pathFilter.GetFullPath())
 			{
 				filteredVolumes.push_back (volume);
 			}
-			else if (wxString (volume->MountPoint) == pathFilter.GetFullPath()
-				|| (wxString (volume->MountPoint) + wxFileName::GetPathSeparator()) == pathFilter.GetFullPath())
+			else if (wxString (wstring(volume->MountPoint)) == pathFilter.GetFullPath()
+                                 || (wxString (wstring(volume->MountPoint)) + wxFileName::GetPathSeparator()) == pathFilter.GetFullPath())
 			{
 				filteredVolumes.push_back (volume);
 			}
diff -ur a/Main/Forms/Forms.cpp b/Main/Forms/Forms.cpp
--- a/Main/Forms/Forms.cpp
+++ b/Main/Forms/Forms.cpp
@@ -263,8 +263,6 @@
 	VolumeStaticBoxSizer = new wxStaticBoxSizer( new wxStaticBox( MainPanel, wxID_ANY, _("Volume") ), wxVERTICAL );
 	
 	VolumeGridBagSizer = new wxGridBagSizer( 0, 0 );
-	VolumeGridBagSizer->AddGrowableCol( 1 );
-	VolumeGridBagSizer->AddGrowableRow( 0 );
 	VolumeGridBagSizer->SetFlexibleDirection( wxBOTH );
 	VolumeGridBagSizer->SetNonFlexibleGrowMode( wxFLEX_GROWMODE_SPECIFIED );
 	
@@ -307,6 +305,9 @@
 	
 	VolumeGridBagSizer->Add( bSizer21, wxGBPosition( 1, 3 ), wxGBSpan( 1, 1 ), wxEXPAND, 5 );
 	
+	VolumeGridBagSizer->AddGrowableCol( 1 );
+	VolumeGridBagSizer->AddGrowableRow( 0 );
+
 	VolumeStaticBoxSizer->Add( VolumeGridBagSizer, 1, wxEXPAND|wxALL, 4 );
 	
 	LowStaticBoxSizer->Add( VolumeStaticBoxSizer, 1, wxEXPAND, 5 );
@@ -1442,7 +1443,6 @@
 	bSizer54->Add( bSizer55, 1, wxEXPAND, 5 );
 	
 	FilesystemOptionsSizer = new wxGridBagSizer( 0, 0 );
-	FilesystemOptionsSizer->AddGrowableCol( 1 );
 	FilesystemOptionsSizer->SetFlexibleDirection( wxBOTH );
 	FilesystemOptionsSizer->SetNonFlexibleGrowMode( wxFLEX_GROWMODE_SPECIFIED );
 	FilesystemOptionsSizer->SetEmptyCellSize( wxSize( 0,0 ) );
@@ -1468,6 +1468,8 @@
 	FilesystemOptionsTextCtrl = new wxTextCtrl( m_panel8, wxID_ANY, wxEmptyString, wxDefaultPosition, wxDefaultSize, 0 );
 	FilesystemOptionsSizer->Add( FilesystemOptionsTextCtrl, wxGBPosition( 2, 1 ), wxGBSpan( 1, 2 ), wxALIGN_CENTER_VERTICAL|wxEXPAND|wxTOP|wxRIGHT|wxLEFT, 5 );
 	
+	FilesystemOptionsSizer->AddGrowableCol( 1 );
+
 	bSizer54->Add( FilesystemOptionsSizer, 0, wxEXPAND, 5 );
 	
 	sbSizer28->Add( bSizer54, 0, wxEXPAND|wxBOTTOM, 5 );
@@ -2892,7 +2894,6 @@
 	bSizer7 = new wxBoxSizer( wxVERTICAL );
 	
 	GridBagSizer = new wxGridBagSizer( 0, 0 );
-	GridBagSizer->AddGrowableCol( 1 );
 	GridBagSizer->SetFlexibleDirection( wxBOTH );
 	GridBagSizer->SetNonFlexibleGrowMode( wxFLEX_GROWMODE_SPECIFIED );
 	GridBagSizer->SetEmptyCellSize( wxSize( 0,0 ) );
@@ -2950,6 +2951,8 @@
 	
 	GridBagSizer->Add( PasswordPlaceholderSizer, wxGBPosition( 8, 1 ), wxGBSpan( 1, 2 ), wxTOP|wxEXPAND, 5 );
 	
+	GridBagSizer->AddGrowableCol( 1 );
+
 	bSizer7->Add( GridBagSizer, 1, wxALL|wxEXPAND, 5 );
 	
 	this->SetSizer( bSizer7 );
diff -ur a/Main/Forms/MainFrame.cpp b/Main/Forms/MainFrame.cpp
--- a/Main/Forms/MainFrame.cpp
+++ b/Main/Forms/MainFrame.cpp
@@ -828,7 +828,7 @@
 			// File-hosted volumes
 			if (!volume->Path.IsDevice() && !mountPoint.IsEmpty())
 			{
-				if (wxString (volume->Path).Upper().StartsWith (wstring (mountPoint).c_str()))
+				if (wxString (wstring(volume->Path)).Upper().StartsWith (wxString (wstring(mountPoint))))
 				{
 					removedVolumes.push_back (volume);
 					continue;
@@ -1020,7 +1020,7 @@
 		if (!ListItemRightClickEventPending)
 		{
 			ListItemRightClickEventPending = true;
-			SlotListCtrl->AddPendingEvent (event);
+			SlotListCtrl->GetEventHandler()->AddPendingEvent (event);
 			return;
 		}
 
diff -ur a/Main/Forms/SelectDirectoryWizardPage.cpp b/Main/Forms/SelectDirectoryWizardPage.cpp
--- a/Main/Forms/SelectDirectoryWizardPage.cpp
+++ b/Main/Forms/SelectDirectoryWizardPage.cpp
@@ -16,7 +16,7 @@
 	{
 		if (!DirectoryTextCtrl->IsEmpty())
 		{
-			return FilesystemPath (DirectoryTextCtrl->GetValue()).IsDirectory();
+			return FilesystemPath (wstring(DirectoryTextCtrl->GetValue())).IsDirectory();
 		}
 
 		return false;
diff -ur a/Main/Forms/SelectDirectoryWizardPage.h b/Main/Forms/SelectDirectoryWizardPage.h
--- a/Main/Forms/SelectDirectoryWizardPage.h
+++ b/Main/Forms/SelectDirectoryWizardPage.h
@@ -18,7 +18,7 @@
 	public:
 		SelectDirectoryWizardPage (wxPanel* parent) : SelectDirectoryWizardPageBase (parent) { }
 
-		DirectoryPath GetDirectory () const { return DirectoryPath (DirectoryTextCtrl->GetValue()); }
+		DirectoryPath GetDirectory () const { return DirectoryPath (wstring(DirectoryTextCtrl->GetValue())); }
 		bool IsValid ();
 		void SetDirectory (const DirectoryPath &path) { DirectoryTextCtrl->SetValue (wstring (path)); }
 		void SetMaxStaticTextWidth (int width) { InfoStaticText->Wrap (width); }
diff -ur a/Main/GraphicUserInterface.cpp b/Main/GraphicUserInterface.cpp
--- a/Main/GraphicUserInterface.cpp
+++ b/Main/GraphicUserInterface.cpp
@@ -1384,7 +1384,7 @@
 #else
 			L"",
 #endif
-			L"", wxDD_DEFAULT_STYLE | (existingOnly ? wxDD_DIR_MUST_EXIST : 0), wxDefaultPosition, parent));
+			L"", wxDD_DEFAULT_STYLE | (existingOnly ? wxDD_DIR_MUST_EXIST : 0), wxDefaultPosition, parent).wc_str());
 	}
 
 	FilePathList GraphicUserInterface::SelectFiles (wxWindow *parent, const wxString &caption, bool saveMode, bool allowMultiple, const list < pair <wstring, wstring> > &fileExtensions, const DirectoryPath &directory) const
@@ -1428,14 +1428,14 @@
 		if (dialog.ShowModal() == wxID_OK)
 		{
 			if (!allowMultiple)
-				files.push_back (make_shared <FilePath> (dialog.GetPath()));
+				files.push_back (make_shared <FilePath> (dialog.GetPath().wc_str()));
 			else
 			{
 				wxArrayString paths;
 				dialog.GetPaths (paths);
 
 				foreach (const wxString &path, paths)
-					files.push_back (make_shared <FilePath> (path));
+					files.push_back (make_shared <FilePath> (path.wc_str()));
 			}
 		}
 
diff -ur a/Main/TextUserInterface.cpp b/Main/TextUserInterface.cpp
--- a/Main/TextUserInterface.cpp
+++ b/Main/TextUserInterface.cpp
@@ -116,7 +116,7 @@
 			for (size_t i = 0; i < length && i < VolumePassword::MaxSize; ++i)
 			{
 				passwordBuf[i] = (wchar_t) passwordStr[i];
-				const_cast <wchar_t *> (passwordStr.c_str())[i] = L'X';
+				const_cast <wchar_t *> (passwordStr.wc_str())[i] = L'X';
 			}
 
 			if (verify && verPhase)
@@ -763,8 +763,8 @@
 
 				ShowString (wxString::Format (L"\rDone: %7.3f%%  Speed: %9s  Left: %s         ",
 					100.0 - double (options->Size - progress.SizeDone) / (double (options->Size) / 100.0),
-					speed > 0 ? SpeedToString (speed).c_str() : L" ",
-					speed > 0 ? TimeSpanToString ((options->Size - progress.SizeDone) / speed).c_str() : L""));
+					speed > 0 ? SpeedToString (speed).wc_str() : L" ",
+					speed > 0 ? TimeSpanToString ((options->Size - progress.SizeDone) / speed).wc_str() : L""));
 			}
 
 			Thread::Sleep (100);
diff -ur a/Main/UserPreferences.cpp b/Main/UserPreferences.cpp
--- a/Main/UserPreferences.cpp
+++ b/Main/UserPreferences.cpp
@@ -219,7 +219,7 @@
 
 			foreach_ref (const Keyfile &keyfile, DefaultKeyfiles)
 			{
-				keyfilesXml.InnerNodes.push_back (XmlNode (L"keyfile", wxString (FilesystemPath (keyfile))));
+				keyfilesXml.InnerNodes.push_back (XmlNode (L"keyfile", wxString (wstring(FilesystemPath (keyfile)))));
 			}
 
 			XmlWriter keyfileWriter (keyfilesCfgPath);
diff -ur a/Platform/Unix/Process.cpp b/Platform/Unix/Process.cpp
--- a/Platform/Unix/Process.cpp
+++ b/Platform/Unix/Process.cpp
@@ -52,9 +52,9 @@
 					if (!execFunctor)
 						args[argIndex++] = const_cast <char*> (processName.c_str());
 
-					foreach (const string &arg, arguments)
+					for (list<string>::const_iterator arg=arguments.begin(); arg != arguments.end(); ++arg)
 					{
-						args[argIndex++] = const_cast <char*> (arg.c_str());
+						args[argIndex++] = const_cast <char*> ((*arg).c_str());
 					}
 					args[argIndex] = nullptr;
 
