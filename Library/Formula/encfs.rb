require 'formula'

class Encfs < Formula
  homepage 'http://www.arg0.net/encfs'
  url 'http://encfs.googlecode.com/files/encfs-1.7.4.tgz'
  sha1 '3d824ba188dbaabdc9e36621afb72c651e6e2945'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'boost'
  depends_on 'rlog'
  depends_on 'osxfuse'

  def patches
    # fixes link times and xattr on links for mac os x
    DATA
  end

  def install
    ENV['CPPFLAGS'] = "-I#{HOMEBREW_PREFIX}/include/osxfuse -I#{Formula.factory('gettext').include}"
    ENV['LDFLAGS'] = "-L#{Formula.factory('gettext').lib}"
    system "mkdir encfs/sys"
    system "cp \"$HOMEBREW_SDKROOT/usr/include/sys/_endian.h\" encfs/sys/endian.h"
    inreplace "configure", "-lfuse", "-losxfuse"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Make sure to follow the directions given by 'brew info osxfuse'
    before trying to use a FUSE-based filesystem.
    EOS
  end
end



__END__
diff --git a/encfs/BlockNameIO.cpp b/encfs/BlockNameIO.cpp
index 27a210b..d4f7855 100644
--- a/encfs/BlockNameIO.cpp
+++ b/encfs/BlockNameIO.cpp
@@ -34,14 +34,14 @@ using namespace boost;
 static RLogChannel * Info = DEF_CHANNEL( "info/nameio", Log_Info );
 
 
-static shared_ptr<NameIO> NewBlockNameIO( const Interface &iface,
-	const shared_ptr<Cipher> &cipher, const CipherKey &key )
+static boost::shared_ptr<NameIO> NewBlockNameIO( const Interface &iface,
+	const boost::shared_ptr<Cipher> &cipher, const CipherKey &key )
 {
     int blockSize = 8;
     if(cipher)
 	blockSize = cipher->cipherBlockSize();
 
-    return shared_ptr<NameIO>( new BlockNameIO( iface, cipher, key, blockSize));
+    return boost::shared_ptr<NameIO>( new BlockNameIO( iface, cipher, key, blockSize));
 }
 
 static bool BlockIO_registered = NameIO::Register("Block",
@@ -72,7 +72,7 @@ Interface BlockNameIO::CurrentInterface()
 }
 
 BlockNameIO::BlockNameIO( const rel::Interface &iface,
-	const shared_ptr<Cipher> &cipher, 
+	const boost::shared_ptr<Cipher> &cipher, 
 	const CipherKey &key, int blockSize )
     : _interface( iface.current() )
     , _bs( blockSize )
diff --git a/encfs/Cipher.cpp b/encfs/Cipher.cpp
index fe00b3a..1445d9d 100644
--- a/encfs/Cipher.cpp
+++ b/encfs/Cipher.cpp
@@ -35,7 +35,6 @@
 
 using namespace std;
 using namespace rel;
-using boost::shared_ptr;
 
 #define REF_MODULE(TYPE)  \
     if( !TYPE::Enabled() ) \
@@ -121,9 +120,9 @@ bool Cipher::Register(const char *name, const char *description,
     return true;
 }
 
-shared_ptr<Cipher> Cipher::New(const string &name, int keyLen)
+boost::shared_ptr<Cipher> Cipher::New(const string &name, int keyLen)
 {
-    shared_ptr<Cipher> result;
+    boost::shared_ptr<Cipher> result;
 
     if(gCipherMap)
     {
@@ -139,9 +138,9 @@ shared_ptr<Cipher> Cipher::New(const string &name, int keyLen)
     return result;
 }
 
-shared_ptr<Cipher> Cipher::New( const Interface &iface, int keyLen )
+boost::shared_ptr<Cipher> Cipher::New( const Interface &iface, int keyLen )
 {
-    shared_ptr<Cipher> result;
+    boost::shared_ptr<Cipher> result;
     if(gCipherMap)
     {
 	CipherMap_t::const_iterator it;
diff --git a/encfs/CipherFileIO.cpp b/encfs/CipherFileIO.cpp
index 11e97a0..6dedbb5 100644
--- a/encfs/CipherFileIO.cpp
+++ b/encfs/CipherFileIO.cpp
@@ -26,8 +26,6 @@
 #include <fcntl.h>
 #include <cerrno>
 
-using boost::shared_ptr;
-
 /*
     - Version 2:0 adds support for a per-file initialization vector with a
       fixed 8 byte header.  The headers are enabled globally within a
@@ -49,7 +47,7 @@ static bool checkSize( int fsBlockSize, int cipherBlockSize )
 	return false;
 }
 
-CipherFileIO::CipherFileIO( const shared_ptr<FileIO> &_base, 
+CipherFileIO::CipherFileIO( const boost::shared_ptr<FileIO> &_base, 
                             const FSConfigPtr &cfg)
     : BlockFileIO( cfg->config->blockSize, cfg )
     , base( _base )
diff --git a/encfs/Context.cpp b/encfs/Context.cpp
index 3ab8435..493703a 100644
--- a/encfs/Context.cpp
+++ b/encfs/Context.cpp
@@ -48,9 +48,9 @@ EncFS_Context::~EncFS_Context()
     openFiles.clear();
 }
 
-shared_ptr<DirNode> EncFS_Context::getRoot(int *errCode)
+boost::shared_ptr<DirNode> EncFS_Context::getRoot(int *errCode)
 {
-    shared_ptr<DirNode> ret;
+    boost::shared_ptr<DirNode> ret;
     do
     {
 	{
@@ -73,7 +73,7 @@ shared_ptr<DirNode> EncFS_Context::getRoot(int *errCode)
     return ret;
 }
 
-void EncFS_Context::setRoot(const shared_ptr<DirNode> &r)
+void EncFS_Context::setRoot(const boost::shared_ptr<DirNode> &r)
 {
     Lock lock( contextMutex );
 
@@ -104,7 +104,7 @@ int EncFS_Context::openFileCount() const
     return openFiles.size();
 }
 
-shared_ptr<FileNode> EncFS_Context::lookupNode(const char *path)
+boost::shared_ptr<FileNode> EncFS_Context::lookupNode(const char *path)
 {
     Lock lock( contextMutex );
 
@@ -116,7 +116,7 @@ shared_ptr<FileNode> EncFS_Context::lookupNode(const char *path)
 	return (*it->second.begin())->node;
     } else
     {
-	return shared_ptr<FileNode>();
+	return boost::shared_ptr<FileNode>();
     }
 }
 
@@ -133,7 +133,7 @@ void EncFS_Context::renameNode(const char *from, const char *to)
     }
 }
 
-shared_ptr<FileNode> EncFS_Context::getNode(void *pl)
+boost::shared_ptr<FileNode> EncFS_Context::getNode(void *pl)
 {
     Placeholder *ph = (Placeholder*)pl;
     return ph->node;
diff --git a/encfs/DirNode.cpp b/encfs/DirNode.cpp
index 91a6580..cea3c7b 100644
--- a/encfs/DirNode.cpp
+++ b/encfs/DirNode.cpp
@@ -57,8 +57,8 @@ public:
 };
 
 
-DirTraverse::DirTraverse(const shared_ptr<DIR> &_dirPtr, 
-	uint64_t _iv, const shared_ptr<NameIO> &_naming)
+DirTraverse::DirTraverse(const boost::shared_ptr<DIR> &_dirPtr, 
+	uint64_t _iv, const boost::shared_ptr<NameIO> &_naming)
     : dir( _dirPtr )
     , iv( _iv )
     , naming( _naming )
@@ -89,7 +89,7 @@ DirTraverse::~DirTraverse()
 }
 
 static
-bool _nextName(struct dirent *&de, const shared_ptr<DIR> &dir, 
+bool _nextName(struct dirent *&de, const boost::shared_ptr<DIR> &dir, 
 	int *fileType, ino_t *inode)
 {
     de = ::readdir( dir.get() );
@@ -173,11 +173,11 @@ class RenameOp
 {
 private:
     DirNode *dn;
-    shared_ptr< list<RenameEl> > renameList;
+    boost::shared_ptr< list<RenameEl> > renameList;
     list<RenameEl>::const_iterator last;
 
 public:
-    RenameOp( DirNode *_dn, const shared_ptr< list<RenameEl> > &_renameList )
+    RenameOp( DirNode *_dn, const boost::shared_ptr< list<RenameEl> > &_renameList )
 	: dn(_dn), renameList(_renameList)
     {
 	last = renameList->begin();
@@ -415,10 +415,10 @@ DirTraverse DirNode::openDir(const char *plaintextPath)
     if(dir == NULL)
     {
 	rDebug("opendir error %s", strerror(errno));
-	return DirTraverse( shared_ptr<DIR>(), 0, shared_ptr<NameIO>() );
+	return DirTraverse( boost::shared_ptr<DIR>(), 0, boost::shared_ptr<NameIO>() );
     } else
     {
-        shared_ptr<DIR> dp( dir, DirDeleter() );
+        boost::shared_ptr<DIR> dp( dir, DirDeleter() );
 
 	uint64_t iv = 0;
 	// if we're using chained IV mode, then compute the IV at this
@@ -454,7 +454,7 @@ bool DirNode::genRenameList( list<RenameEl> &renameList,
 
     // generate the real destination path, where we expect to find the files..
     rDebug("opendir %s", sourcePath.c_str() );
-    shared_ptr<DIR> dir = shared_ptr<DIR>(
+    boost::shared_ptr<DIR> dir = boost::shared_ptr<DIR>(
 	    opendir( sourcePath.c_str() ), DirDeleter() );
     if(!dir)
 	return false;
@@ -556,18 +556,18 @@ bool DirNode::genRenameList( list<RenameEl> &renameList,
 
     Returns a list of renamed items on success, a null list on failure.
 */
-shared_ptr<RenameOp>
+boost::shared_ptr<RenameOp>
 DirNode::newRenameOp( const char *fromP, const char *toP )
 {
     // Do the rename in two stages to avoid chasing our tail
     // Undo everything if we encounter an error!
-    shared_ptr< list<RenameEl> > renameList(new list<RenameEl>);
+    boost::shared_ptr< list<RenameEl> > renameList(new list<RenameEl>);
     if(!genRenameList( *renameList.get(), fromP, toP ))
     {
 	rWarning("Error during generation of recursive rename list");
-	return shared_ptr<RenameOp>();
+	return boost::shared_ptr<RenameOp>();
     } else
-	return shared_ptr<RenameOp>( new RenameOp(this, renameList) );
+	return boost::shared_ptr<RenameOp>( new RenameOp(this, renameList) );
 }
 
 
@@ -618,9 +618,9 @@ DirNode::rename( const char *fromPlaintext, const char *toPlaintext )
     
     rLog( Info, "rename %s -> %s", fromCName.c_str(), toCName.c_str() );
    
-    shared_ptr<FileNode> toNode = findOrCreate( toPlaintext );
+    boost::shared_ptr<FileNode> toNode = findOrCreate( toPlaintext );
 
-    shared_ptr<RenameOp> renameOp;
+    boost::shared_ptr<RenameOp> renameOp;
     if( hasDirectoryNameDependency() && isDirectory( fromCName.c_str() ))
     {
 	rLog( Info, "recursive rename begin" );
@@ -709,15 +709,15 @@ int DirNode::link( const char *from, const char *to )
     The node is keyed by filename, so a rename means the internal node names
     must be changed.
 */
-shared_ptr<FileNode> DirNode::renameNode( const char *from, const char *to )
+boost::shared_ptr<FileNode> DirNode::renameNode( const char *from, const char *to )
 {
     return renameNode( from, to, true );
 }
 
-shared_ptr<FileNode> DirNode::renameNode( const char *from, const char *to, 
+boost::shared_ptr<FileNode> DirNode::renameNode( const char *from, const char *to, 
 	bool forwardMode )
 {
-    shared_ptr<FileNode> node = findOrCreate( from );
+    boost::shared_ptr<FileNode> node = findOrCreate( from );
 
     if(node)
     {
@@ -742,17 +742,17 @@ shared_ptr<FileNode> DirNode::renameNode( const char *from, const char *to,
     return node;
 }
 
-shared_ptr<FileNode> DirNode::directLookup( const char *path )
+boost::shared_ptr<FileNode> DirNode::directLookup( const char *path )
 {
-    return shared_ptr<FileNode>( 
+    return boost::shared_ptr<FileNode>( 
             new FileNode( this, 
                 fsConfig,
                 "unknown", path ));
 }
 
-shared_ptr<FileNode> DirNode::findOrCreate( const char *plainName)
+boost::shared_ptr<FileNode> DirNode::findOrCreate( const char *plainName)
 {
-    shared_ptr<FileNode> node;
+    boost::shared_ptr<FileNode> node;
     if(ctx)
 	node = ctx->lookupNode( plainName );
 
@@ -773,13 +773,13 @@ shared_ptr<FileNode> DirNode::findOrCreate( const char *plainName)
     return node;
 }
 
-shared_ptr<FileNode>
+boost::shared_ptr<FileNode>
 DirNode::lookupNode( const char *plainName, const char * requestor )
 {
     (void)requestor;
     Lock _lock( mutex );
 
-    shared_ptr<FileNode> node = findOrCreate( plainName );
+    boost::shared_ptr<FileNode> node = findOrCreate( plainName );
 
     return node;
 }
@@ -789,7 +789,7 @@ DirNode::lookupNode( const char *plainName, const char * requestor )
     node on sucess..  This is done in one step to avoid any race conditions
     with the stored state of the file.
 */
-shared_ptr<FileNode>
+boost::shared_ptr<FileNode>
 DirNode::openNode( const char *plainName, const char * requestor, int flags,
 	int *result )
 {
@@ -797,12 +797,12 @@ DirNode::openNode( const char *plainName, const char * requestor, int flags,
     rAssert( result != NULL );
     Lock _lock( mutex );
 
-    shared_ptr<FileNode> node = findOrCreate( plainName );
+    boost::shared_ptr<FileNode> node = findOrCreate( plainName );
 
     if( node && (*result = node->open( flags )) >= 0 )
 	return node;
     else
-	return shared_ptr<FileNode>();
+	return boost::shared_ptr<FileNode>();
 }
 
 int DirNode::unlink( const char *plaintextName )
diff --git a/encfs/FileNode.cpp b/encfs/FileNode.cpp
index 4d15037..938f43b 100644
--- a/encfs/FileNode.cpp
+++ b/encfs/FileNode.cpp
@@ -77,11 +77,11 @@ FileNode::FileNode(DirNode *parent_, const FSConfigPtr &cfg,
     this->fsConfig = cfg;
 
     // chain RawFileIO & CipherFileIO
-    shared_ptr<FileIO> rawIO( new RawFileIO( _cname ) );
-    io = shared_ptr<FileIO>( new CipherFileIO( rawIO, fsConfig ));
+    boost::shared_ptr<FileIO> rawIO( new RawFileIO( _cname ) );
+    io = boost::shared_ptr<FileIO>( new CipherFileIO( rawIO, fsConfig ));
 
     if(cfg->config->blockMACBytes || cfg->config->blockMACRandBytes)
-        io = shared_ptr<FileIO>(new MACFileIO(io, fsConfig));
+        io = boost::shared_ptr<FileIO>(new MACFileIO(io, fsConfig));
 }
 
 FileNode::~FileNode()
@@ -111,7 +111,7 @@ string FileNode::plaintextParent() const
     return parentDirectory( _pname );
 }
 
-static bool setIV(const shared_ptr<FileIO> &io, uint64_t iv)
+static bool setIV(const boost::shared_ptr<FileIO> &io, uint64_t iv)
 {
     struct stat stbuf;
     if((io->getAttr(&stbuf) < 0) || S_ISREG(stbuf.st_mode))
diff --git a/encfs/FileUtils.cpp b/encfs/FileUtils.cpp
index 32afb5d..3839a87 100644
--- a/encfs/FileUtils.cpp
+++ b/encfs/FileUtils.cpp
@@ -967,7 +967,7 @@ bool selectZeroBlockPassThrough()
 }
 
 RootPtr createV6Config( EncFS_Context *ctx,
-        const shared_ptr<EncFS_Opts> &opts )
+        const boost::shared_ptr<EncFS_Opts> &opts )
 {
     const std::string rootDir = opts->rootDir;
     bool enableIdleTracking = opts->idleTracking;
@@ -1111,7 +1111,7 @@ RootPtr createV6Config( EncFS_Context *ctx,
 	}
     }
 
-    shared_ptr<Cipher> cipher = Cipher::New( alg.name, keySize );
+    boost::shared_ptr<Cipher> cipher = Cipher::New( alg.name, keySize );
     if(!cipher)
     {
 	rError(_("Unable to instanciate cipher %s, key size %i, block size %i"),
@@ -1123,7 +1123,7 @@ RootPtr createV6Config( EncFS_Context *ctx,
 	    alg.name.c_str(), keySize, blockSize);
     }
     
-    shared_ptr<EncFSConfig> config( new EncFSConfig );
+    boost::shared_ptr<EncFSConfig> config( new EncFSConfig );
 
     config->cfgType = Config_V6;
     config->cipherIface = cipher->interface();
@@ -1202,7 +1202,7 @@ RootPtr createV6Config( EncFS_Context *ctx,
 	return rootInfo;
 
     // fill in config struct
-    shared_ptr<NameIO> nameCoder = NameIO::New( config->nameIface,
+    boost::shared_ptr<NameIO> nameCoder = NameIO::New( config->nameIface,
 	    cipher, volumeKey );
     if(!nameCoder)
     {
@@ -1228,7 +1228,7 @@ RootPtr createV6Config( EncFS_Context *ctx,
     rootInfo = RootPtr( new EncFS_Root );
     rootInfo->cipher = cipher;
     rootInfo->volumeKey = volumeKey;
-    rootInfo->root = shared_ptr<DirNode>( 
+    rootInfo->root = boost::shared_ptr<DirNode>( 
             new DirNode( ctx, rootDir, fsConfig ));
 
     return rootInfo;
@@ -1236,7 +1236,7 @@ RootPtr createV6Config( EncFS_Context *ctx,
 
 void showFSInfo( const boost::shared_ptr<EncFSConfig> &config )
 {
-    shared_ptr<Cipher> cipher = Cipher::New( config->cipherIface, -1 );
+    boost::shared_ptr<Cipher> cipher = Cipher::New( config->cipherIface, -1 );
     {
 	cout << autosprintf(
 		// xgroup(diag)
@@ -1266,7 +1266,7 @@ void showFSInfo( const boost::shared_ptr<EncFSConfig> &config )
                 config->nameIface.revision(), config->nameIface.age());
 	    
 	// check if we support the filename encoding interface..
-        shared_ptr<NameIO> nameCoder = NameIO::New( config->nameIface,
+        boost::shared_ptr<NameIO> nameCoder = NameIO::New( config->nameIface,
     		cipher, CipherKey() );
 	if(!nameCoder)
 	{
@@ -1349,7 +1349,7 @@ void showFSInfo( const boost::shared_ptr<EncFSConfig> &config )
     cout << "\n";
 }
    
-shared_ptr<Cipher> EncFSConfig::getCipher() const
+boost::shared_ptr<Cipher> EncFSConfig::getCipher() const
 {
     return Cipher::New( cipherIface, keySize );
 }
@@ -1382,7 +1382,7 @@ unsigned char *EncFSConfig::getSaltData() const
 CipherKey EncFSConfig::makeKey(const char *password, int passwdLen)
 {
     CipherKey userKey;
-    shared_ptr<Cipher> cipher = getCipher();
+    boost::shared_ptr<Cipher> cipher = getCipher();
 
     // if no salt is set and we're creating a new password for a new
     // FS type, then initialize salt..
@@ -1580,7 +1580,7 @@ CipherKey EncFSConfig::getNewUserKey()
     return userKey;
 }
 
-RootPtr initFS( EncFS_Context *ctx, const shared_ptr<EncFS_Opts> &opts )
+RootPtr initFS( EncFS_Context *ctx, const boost::shared_ptr<EncFS_Opts> &opts )
 {
     RootPtr rootInfo;
     boost::shared_ptr<EncFSConfig> config(new EncFSConfig);
@@ -1599,7 +1599,7 @@ RootPtr initFS( EncFS_Context *ctx, const shared_ptr<EncFS_Opts> &opts )
 	}
 
         // first, instanciate the cipher.
-	shared_ptr<Cipher> cipher = config->getCipher();
+	boost::shared_ptr<Cipher> cipher = config->getCipher();
 	if(!cipher)
 	{
 	    rError(_("Unable to find cipher %s, version %i:%i:%i"),
@@ -1638,7 +1638,7 @@ RootPtr initFS( EncFS_Context *ctx, const shared_ptr<EncFS_Opts> &opts )
 	    return rootInfo;
 	}
 
-	shared_ptr<NameIO> nameCoder = NameIO::New( config->nameIface, 
+	boost::shared_ptr<NameIO> nameCoder = NameIO::New( config->nameIface, 
 		cipher, volumeKey );
 	if(!nameCoder)
 	{
@@ -1668,7 +1668,7 @@ RootPtr initFS( EncFS_Context *ctx, const shared_ptr<EncFS_Opts> &opts )
 	rootInfo = RootPtr( new EncFS_Root );
 	rootInfo->cipher = cipher;
 	rootInfo->volumeKey = volumeKey;
-	rootInfo->root = shared_ptr<DirNode>( 
+	rootInfo->root = boost::shared_ptr<DirNode>( 
                 new DirNode( ctx, opts->rootDir, fsConfig ));
     } else
     {
diff --git a/encfs/MACFileIO.cpp b/encfs/MACFileIO.cpp
index 816e64b..d281a40 100644
--- a/encfs/MACFileIO.cpp
+++ b/encfs/MACFileIO.cpp
@@ -57,7 +57,7 @@ int dataBlockSize(const FSConfigPtr &cfg)
             - cfg->config->blockMACRandBytes;
 }
 
-MACFileIO::MACFileIO( const shared_ptr<FileIO> &_base,
+MACFileIO::MACFileIO( const boost::shared_ptr<FileIO> &_base,
                       const FSConfigPtr &cfg )
    : BlockFileIO( dataBlockSize( cfg ), cfg )
    , base( _base )
diff --git a/encfs/NameIO.cpp b/encfs/NameIO.cpp
index a13694f..e6eed70 100644
--- a/encfs/NameIO.cpp
+++ b/encfs/NameIO.cpp
@@ -104,10 +104,10 @@ bool NameIO::Register( const char *name, const char *description,
     return true;
 }
 
-shared_ptr<NameIO> NameIO::New( const string &name, 
-	const shared_ptr<Cipher> &cipher, const CipherKey &key)
+boost::shared_ptr<NameIO> NameIO::New( const string &name, 
+	const boost::shared_ptr<Cipher> &cipher, const CipherKey &key)
 {
-    shared_ptr<NameIO> result;
+    boost::shared_ptr<NameIO> result;
     if(gNameIOMap)
     {
 	NameIOMap_t::const_iterator it = gNameIOMap->find( name );
@@ -120,10 +120,10 @@ shared_ptr<NameIO> NameIO::New( const string &name,
     return result;
 }
 
-shared_ptr<NameIO> NameIO::New( const Interface &iface, 
-	const shared_ptr<Cipher> &cipher, const CipherKey &key )
+boost::shared_ptr<NameIO> NameIO::New( const Interface &iface, 
+	const boost::shared_ptr<Cipher> &cipher, const CipherKey &key )
 {
-    shared_ptr<NameIO> result;
+    boost::shared_ptr<NameIO> result;
     if(gNameIOMap)
     {
 	NameIOMap_t::const_iterator it;
diff --git a/encfs/NullCipher.cpp b/encfs/NullCipher.cpp
index fa6ca72..d5391be 100644
--- a/encfs/NullCipher.cpp
+++ b/encfs/NullCipher.cpp
@@ -28,7 +28,6 @@
 using namespace std;
 using namespace rel;
 using namespace rlog;
-using boost::shared_ptr;
 using boost::dynamic_pointer_cast;
 
 
@@ -36,10 +35,10 @@ static Interface NullInterface( "nullCipher", 1, 0, 0 );
 static Range NullKeyRange(0);
 static Range NullBlockRange(1,4096,1);
 
-static shared_ptr<Cipher> NewNullCipher(const Interface &iface, int keyLen)
+static boost::shared_ptr<Cipher> NewNullCipher(const Interface &iface, int keyLen)
 {
     (void)keyLen;
-    return shared_ptr<Cipher>( new NullCipher( iface ) );
+    return boost::shared_ptr<Cipher>( new NullCipher( iface ) );
 }
 
 const bool HiddenCipher = true;
@@ -67,7 +66,7 @@ public:
     void operator ()(NullKey *&) {}
 };
 
-shared_ptr<AbstractCipherKey> gNullKey( new NullKey(), NullDestructor() );
+boost::shared_ptr<AbstractCipherKey> gNullKey( new NullKey(), NullDestructor() );
 
 NullCipher::NullCipher(const Interface &iface_)
 {
@@ -125,8 +124,8 @@ void NullCipher::writeKey(const CipherKey &, unsigned char *,
 bool NullCipher::compareKey(const CipherKey &A_, 
 	const CipherKey &B_) const
 {
-    shared_ptr<NullKey> A = dynamic_pointer_cast<NullKey>(A_);
-    shared_ptr<NullKey> B = dynamic_pointer_cast<NullKey>(B_);
+    boost::shared_ptr<NullKey> A = dynamic_pointer_cast<NullKey>(A_);
+    boost::shared_ptr<NullKey> B = dynamic_pointer_cast<NullKey>(B_);
     return A.get() == B.get();
 }
 
diff --git a/encfs/NullNameIO.cpp b/encfs/NullNameIO.cpp
index 90485ef..fcd82b8 100644
--- a/encfs/NullNameIO.cpp
+++ b/encfs/NullNameIO.cpp
@@ -23,12 +23,11 @@
 #include <cstring>
 
 using namespace rel;
-using boost::shared_ptr;
 
-static shared_ptr<NameIO> NewNNIO( const Interface &, 
-	const shared_ptr<Cipher> &, const CipherKey & )
+static boost::shared_ptr<NameIO> NewNNIO( const Interface &, 
+	const boost::shared_ptr<Cipher> &, const CipherKey & )
 {
-    return shared_ptr<NameIO>( new NullNameIO() );
+    return boost::shared_ptr<NameIO>( new NullNameIO() );
 }
 
 static Interface NNIOIface("nameio/null", 1, 0, 0);
diff --git a/encfs/SSL_Cipher.cpp b/encfs/SSL_Cipher.cpp
index a6e9290..d6ac666 100644
--- a/encfs/SSL_Cipher.cpp
+++ b/encfs/SSL_Cipher.cpp
@@ -46,7 +46,6 @@ using namespace std;
 using namespace rel;
 using namespace rlog;
 
-using boost::shared_ptr;
 using boost::dynamic_pointer_cast;
 
 const int MAX_KEYLENGTH = 32; // in bytes (256 bit)
@@ -182,7 +181,7 @@ static Interface AESInterface( "ssl/aes", 3, 0, 2 );
 static Range BFKeyRange(128,256,32);
 static Range BFBlockRange(64,4096,8);
 
-static shared_ptr<Cipher> NewBFCipher( const Interface &iface, int keyLen )
+static boost::shared_ptr<Cipher> NewBFCipher( const Interface &iface, int keyLen )
 {
     if( keyLen <= 0 )
 	keyLen = 160;
@@ -192,7 +191,7 @@ static shared_ptr<Cipher> NewBFCipher( const Interface &iface, int keyLen )
     const EVP_CIPHER *blockCipher = EVP_bf_cbc();
     const EVP_CIPHER *streamCipher = EVP_bf_cfb();
 
-    return shared_ptr<Cipher>( new SSL_Cipher(iface, BlowfishInterface,
+    return boost::shared_ptr<Cipher>( new SSL_Cipher(iface, BlowfishInterface,
 	    blockCipher, streamCipher, keyLen / 8) );
 }
 
@@ -208,7 +207,7 @@ static bool BF_Cipher_registered = Cipher::Register("Blowfish",
 static Range AESKeyRange(128,256,64);
 static Range AESBlockRange(64,4096,16);
 
-static shared_ptr<Cipher> NewAESCipher( const Interface &iface, int keyLen )
+static boost::shared_ptr<Cipher> NewAESCipher( const Interface &iface, int keyLen )
 {
     if( keyLen <= 0 )
 	keyLen = 192;
@@ -237,7 +236,7 @@ static shared_ptr<Cipher> NewAESCipher( const Interface &iface, int keyLen )
 	break;
     }
     
-    return shared_ptr<Cipher>( new SSL_Cipher(iface, AESInterface, 
+    return boost::shared_ptr<Cipher>( new SSL_Cipher(iface, AESInterface, 
 		blockCipher, streamCipher, keyLen / 8) );
 }
 
@@ -304,16 +303,16 @@ SSLKey::~SSLKey()
 }
 
 
-inline unsigned char* KeyData( const shared_ptr<SSLKey> &key )
+inline unsigned char* KeyData( const boost::shared_ptr<SSLKey> &key )
 {
     return key->buffer;
 }
-inline unsigned char* IVData( const shared_ptr<SSLKey> &key )
+inline unsigned char* IVData( const boost::shared_ptr<SSLKey> &key )
 {
     return key->buffer + key->keySize;
 }
 
-void initKey(const shared_ptr<SSLKey> &key, const EVP_CIPHER *_blockCipher,
+void initKey(const boost::shared_ptr<SSLKey> &key, const EVP_CIPHER *_blockCipher,
 	const EVP_CIPHER *_streamCipher, int _keySize)
 {
     Lock lock( key->mutex );
@@ -400,7 +399,7 @@ CipherKey SSL_Cipher::newKey(const char *password, int passwdLength,
         int &iterationCount, long desiredDuration,
         const unsigned char *salt, int saltLen)
 {
-    shared_ptr<SSLKey> key( new SSLKey( _keySize, _ivLength) );
+    boost::shared_ptr<SSLKey> key( new SSLKey( _keySize, _ivLength) );
     
     if(iterationCount == 0)
     {
@@ -435,7 +434,7 @@ CipherKey SSL_Cipher::newKey(const char *password, int passwdLength,
 
 CipherKey SSL_Cipher::newKey(const char *password, int passwdLength)
 {
-    shared_ptr<SSLKey> key( new SSLKey( _keySize, _ivLength) );
+    boost::shared_ptr<SSLKey> key( new SSLKey( _keySize, _ivLength) );
     
     int bytes = 0;
     if( iface.current() > 1 )
@@ -484,7 +483,7 @@ CipherKey SSL_Cipher::newRandomKey()
        !randomize(saltBuf, saltLen, true))
         return CipherKey();
 
-    shared_ptr<SSLKey> key( new SSLKey( _keySize, _ivLength) );
+    boost::shared_ptr<SSLKey> key( new SSLKey( _keySize, _ivLength) );
 
     // doesn't need to be versioned, because a random key is a random key..
     // Doesn't need to be reproducable..
@@ -572,7 +571,7 @@ bool SSL_Cipher::randomize( unsigned char *buf, int len,
 uint64_t SSL_Cipher::MAC_64( const unsigned char *data, int len,
 	const CipherKey &key, uint64_t *chainedIV ) const
 {
-    shared_ptr<SSLKey> mk = dynamic_pointer_cast<SSLKey>(key);
+    boost::shared_ptr<SSLKey> mk = dynamic_pointer_cast<SSLKey>(key);
     uint64_t tmp = _checksum_64( mk.get(), data, len, chainedIV );
 
     if(chainedIV)
@@ -584,7 +583,7 @@ uint64_t SSL_Cipher::MAC_64( const unsigned char *data, int len,
 CipherKey SSL_Cipher::readKey(const unsigned char *data, 
 	const CipherKey &masterKey, bool checkKey)
 {
-    shared_ptr<SSLKey> mk = dynamic_pointer_cast<SSLKey>(masterKey);
+    boost::shared_ptr<SSLKey> mk = dynamic_pointer_cast<SSLKey>(masterKey);
     rAssert(mk->keySize == _keySize);
     
     unsigned char tmpBuf[ MAX_KEYLENGTH + MAX_IVLENGTH ];
@@ -607,7 +606,7 @@ CipherKey SSL_Cipher::readKey(const unsigned char *data,
 	return CipherKey();
     }
     
-    shared_ptr<SSLKey> key( new SSLKey( _keySize, _ivLength) );
+    boost::shared_ptr<SSLKey> key( new SSLKey( _keySize, _ivLength) );
     
     memcpy( key->buffer, tmpBuf, _keySize + _ivLength );
     memset( tmpBuf, 0, sizeof(tmpBuf) );
@@ -620,11 +619,11 @@ CipherKey SSL_Cipher::readKey(const unsigned char *data,
 void SSL_Cipher::writeKey(const CipherKey &ckey, unsigned char *data, 
 	const CipherKey &masterKey)
 {
-    shared_ptr<SSLKey> key = dynamic_pointer_cast<SSLKey>(ckey);
+    boost::shared_ptr<SSLKey> key = dynamic_pointer_cast<SSLKey>(ckey);
     rAssert(key->keySize == _keySize);
     rAssert(key->ivLength == _ivLength);
 
-    shared_ptr<SSLKey> mk = dynamic_pointer_cast<SSLKey>(masterKey);
+    boost::shared_ptr<SSLKey> mk = dynamic_pointer_cast<SSLKey>(masterKey);
     rAssert(mk->keySize == _keySize);
     rAssert(mk->ivLength == _ivLength);
 
@@ -650,8 +649,8 @@ void SSL_Cipher::writeKey(const CipherKey &ckey, unsigned char *data,
 
 bool SSL_Cipher::compareKey( const CipherKey &A, const CipherKey &B) const
 {
-    shared_ptr<SSLKey> key1 = dynamic_pointer_cast<SSLKey>(A);
-    shared_ptr<SSLKey> key2 = dynamic_pointer_cast<SSLKey>(B);
+    boost::shared_ptr<SSLKey> key1 = dynamic_pointer_cast<SSLKey>(A);
+    boost::shared_ptr<SSLKey> key2 = dynamic_pointer_cast<SSLKey>(B);
 
     rAssert(key1->keySize == _keySize);
     rAssert(key2->keySize == _keySize);
@@ -678,7 +677,7 @@ int SSL_Cipher::cipherBlockSize() const
 }
 
 void SSL_Cipher::setIVec( unsigned char *ivec, uint64_t seed,
-	const shared_ptr<SSLKey> &key) const
+	const boost::shared_ptr<SSLKey> &key) const
 {
     if (iface.current() >= 3)
     {
@@ -715,7 +714,7 @@ void SSL_Cipher::setIVec( unsigned char *ivec, uint64_t seed,
   */
 void SSL_Cipher::setIVec_old(unsigned char *ivec,
                              unsigned int seed,
-                             const shared_ptr<SSLKey> &key) const
+                             const boost::shared_ptr<SSLKey> &key) const
 {
     /* These multiplication constants chosen as they represent (non optimal)
        Golumb rulers, the idea being to spread around the information in the
@@ -789,7 +788,7 @@ bool SSL_Cipher::streamEncode(unsigned char *buf, int size,
 	uint64_t iv64, const CipherKey &ckey) const
 {
     rAssert( size > 0 );
-    shared_ptr<SSLKey> key = dynamic_pointer_cast<SSLKey>(ckey);
+    boost::shared_ptr<SSLKey> key = dynamic_pointer_cast<SSLKey>(ckey);
     rAssert(key->keySize == _keySize);
     rAssert(key->ivLength == _ivLength);
 
@@ -827,7 +826,7 @@ bool SSL_Cipher::streamDecode(unsigned char *buf, int size,
 	uint64_t iv64, const CipherKey &ckey) const
 {
     rAssert( size > 0 );
-    shared_ptr<SSLKey> key = dynamic_pointer_cast<SSLKey>(ckey);
+    boost::shared_ptr<SSLKey> key = dynamic_pointer_cast<SSLKey>(ckey);
     rAssert(key->keySize == _keySize);
     rAssert(key->ivLength == _ivLength);
 
@@ -866,7 +865,7 @@ bool SSL_Cipher::blockEncode(unsigned char *buf, int size,
 	uint64_t iv64, const CipherKey &ckey ) const
 {
     rAssert( size > 0 );
-    shared_ptr<SSLKey> key = dynamic_pointer_cast<SSLKey>(ckey);
+    boost::shared_ptr<SSLKey> key = dynamic_pointer_cast<SSLKey>(ckey);
     rAssert(key->keySize == _keySize);
     rAssert(key->ivLength == _ivLength);
     
@@ -900,7 +899,7 @@ bool SSL_Cipher::blockDecode(unsigned char *buf, int size,
 	uint64_t iv64, const CipherKey &ckey ) const
 {
     rAssert( size > 0 );
-    shared_ptr<SSLKey> key = dynamic_pointer_cast<SSLKey>(ckey);
+    boost::shared_ptr<SSLKey> key = dynamic_pointer_cast<SSLKey>(ckey);
     rAssert(key->keySize == _keySize);
     rAssert(key->ivLength == _ivLength);
 
diff --git a/encfs/StreamNameIO.cpp b/encfs/StreamNameIO.cpp
index cd7f4a4..93ce132 100644
--- a/encfs/StreamNameIO.cpp
+++ b/encfs/StreamNameIO.cpp
@@ -29,10 +29,10 @@
 using namespace rel;
 using namespace std;
 
-static shared_ptr<NameIO> NewStreamNameIO( const Interface &iface,
-	const shared_ptr<Cipher> &cipher, const CipherKey &key)
+static boost::shared_ptr<NameIO> NewStreamNameIO( const Interface &iface,
+	const boost::shared_ptr<Cipher> &cipher, const CipherKey &key)
 {
-    return shared_ptr<NameIO>( new StreamNameIO( iface, cipher, key ) );
+    return boost::shared_ptr<NameIO>( new StreamNameIO( iface, cipher, key ) );
 }
 
 static bool StreamIO_registered = NameIO::Register("Stream",
@@ -69,7 +69,7 @@ Interface StreamNameIO::CurrentInterface()
 }
 
 StreamNameIO::StreamNameIO( const rel::Interface &iface,
-	const shared_ptr<Cipher> &cipher, 
+	const boost::shared_ptr<Cipher> &cipher, 
 	const CipherKey &key )
     : _interface( iface.current() )
     , _cipher( cipher )
diff --git a/encfs/encfs.cpp b/encfs/encfs.cpp
index dac15bd..ec1fb7e 100644
--- a/encfs/encfs.cpp
+++ b/encfs/encfs.cpp
@@ -82,7 +82,7 @@ static int withCipherPath( const char *opName, const char *path,
     EncFS_Context *ctx = context();
 
     int res = -EIO;
-    shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
+    boost::shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
     if(!FSRoot)
 	return res;
 
@@ -117,13 +117,13 @@ static int withFileNode( const char *opName,
     EncFS_Context *ctx = context();
 
     int res = -EIO;
-    shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
+    boost::shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
     if(!FSRoot)
 	return res;
 
     try
     {
-	shared_ptr<FileNode> fnode;
+	boost::shared_ptr<FileNode> fnode;
 
 	if(fi != NULL)
 	    fnode = GET_FN(ctx, fi);
@@ -161,7 +161,7 @@ int _do_getattr(FileNode *fnode, struct stat *stbuf)
     if(res == ESUCCESS && S_ISLNK(stbuf->st_mode))
     {
 	EncFS_Context *ctx = context();
-	shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
+	boost::shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
 	if(FSRoot)
 	{
 	    // determine plaintext link size..  Easiest to read and decrypt..
@@ -201,7 +201,7 @@ int encfs_getdir(const char *path, fuse_dirh_t h, fuse_dirfil_t filler)
     EncFS_Context *ctx = context();
 
     int res = ESUCCESS;
-    shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
+    boost::shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
     if(!FSRoot)
 	return res;
 
@@ -246,13 +246,13 @@ int encfs_mknod(const char *path, mode_t mode, dev_t rdev)
     EncFS_Context *ctx = context();
 
     int res = -EIO;
-    shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
+    boost::shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
     if(!FSRoot)
 	return res;
 
     try
     {
-	shared_ptr<FileNode> fnode = FSRoot->lookupNode( path, "mknod" );
+	boost::shared_ptr<FileNode> fnode = FSRoot->lookupNode( path, "mknod" );
 
 	rLog(Info, "mknod on %s, mode %i, dev %" PRIi64,
 		fnode->cipherName(), mode, (int64_t)rdev);
@@ -272,7 +272,7 @@ int encfs_mknod(const char *path, mode_t mode, dev_t rdev)
 	    // try again using the parent dir's group
 	    string parent = fnode->plaintextParent();
 	    rInfo("trying public filesystem workaround for %s", parent.c_str());
-	    shared_ptr<FileNode> dnode = 
+	    boost::shared_ptr<FileNode> dnode = 
 		FSRoot->lookupNode( parent.c_str(), "mknod" );
 
 	    struct stat st;
@@ -293,7 +293,7 @@ int encfs_mkdir(const char *path, mode_t mode)
     EncFS_Context *ctx = context();
 
     int res = -EIO;
-    shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
+    boost::shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
     if(!FSRoot)
 	return res;
 
@@ -312,7 +312,7 @@ int encfs_mkdir(const char *path, mode_t mode)
 	{
 	    // try again using the parent dir's group
 	    string parent = parentDirectory( path );
-	    shared_ptr<FileNode> dnode = 
+	    boost::shared_ptr<FileNode> dnode = 
 		FSRoot->lookupNode( parent.c_str(), "mkdir" );
 
 	    struct stat st;
@@ -332,7 +332,7 @@ int encfs_unlink(const char *path)
     EncFS_Context *ctx = context();
 
     int res = -EIO;
-    shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
+    boost::shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
     if(!FSRoot)
 	return res;
 
@@ -367,7 +367,7 @@ int _do_readlink(EncFS_Context *ctx, const string &cyName,
     size_t size = data.get<1>();
 
     int res = ESUCCESS;
-    shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
+    boost::shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
     if(!FSRoot)
 	return res;
 
@@ -407,7 +407,7 @@ int encfs_symlink(const char *from, const char *to)
     EncFS_Context *ctx = context();
 
     int res = -EIO;
-    shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
+    boost::shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
     if(!FSRoot)
 	return res;
 
@@ -452,7 +452,7 @@ int encfs_link(const char *from, const char *to)
     EncFS_Context *ctx = context();
 
     int res = -EIO;
-    shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
+    boost::shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
     if(!FSRoot)
 	return res;
 
@@ -472,7 +472,7 @@ int encfs_rename(const char *from, const char *to)
     EncFS_Context *ctx = context();
 
     int res = -EIO;
-    shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
+    boost::shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
     if(!FSRoot)
 	return res;
 
@@ -558,13 +558,13 @@ int encfs_open(const char *path, struct fuse_file_info *file)
     EncFS_Context *ctx = context();
 
     int res = -EIO;
-    shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
+    boost::shared_ptr<DirNode> FSRoot = ctx->getRoot(&res);
     if(!FSRoot)
 	return res;
 
     try
     {
-	shared_ptr<FileNode> fnode = 
+	boost::shared_ptr<FileNode> fnode = 
 	    FSRoot->openNode( path, "open", file->flags, &res );
 
 	if(fnode)
diff --git a/encfs/encfsctl.cpp b/encfs/encfsctl.cpp
index f2f8d52..2d13e46 100644
--- a/encfs/encfsctl.cpp
+++ b/encfs/encfsctl.cpp
@@ -223,7 +223,7 @@ static int showInfo( int argc, char **argv )
 static RootPtr initRootInfo(int &argc, char ** &argv)
 {
     RootPtr result;
-    shared_ptr<EncFS_Opts> opts( new EncFS_Opts() );
+    boost::shared_ptr<EncFS_Opts> opts( new EncFS_Opts() );
     opts->createIfNotFound = false;
     opts->checkKey = false;
 
@@ -282,7 +282,7 @@ static RootPtr initRootInfo(const char* crootDir)
 
     if(checkDir( rootDir ))
     {
-	shared_ptr<EncFS_Opts> opts( new EncFS_Opts() );
+	boost::shared_ptr<EncFS_Opts> opts( new EncFS_Opts() );
 	opts->rootDir = rootDir;
 	opts->createIfNotFound = false;
 	opts->checkKey = false;
@@ -378,7 +378,7 @@ static int cmd_ls( int argc, char **argv )
 	    for(string name = dt.nextPlaintextName(); !name.empty(); 
 		    name = dt.nextPlaintextName())
 	    {
-		shared_ptr<FileNode> fnode = 
+		boost::shared_ptr<FileNode> fnode = 
 		    rootInfo->root->lookupNode( name.c_str(), "encfsctl-ls" );
 		struct stat stbuf;
 		fnode->getAttr( &stbuf );
@@ -402,11 +402,11 @@ static int cmd_ls( int argc, char **argv )
 
 // apply an operation to every block in the file
 template<typename T>
-int processContents( const shared_ptr<EncFS_Root> &rootInfo, 
+int processContents( const boost::shared_ptr<EncFS_Root> &rootInfo, 
 	const char *path, T &op )
 {
     int errCode = 0;
-    shared_ptr<FileNode> node = rootInfo->root->openNode( path, "encfsctl",
+    boost::shared_ptr<FileNode> node = rootInfo->root->openNode( path, "encfsctl",
 	    O_RDONLY, &errCode );
 
     if(!node)
@@ -470,7 +470,7 @@ static int cmd_cat( int argc, char **argv )
 }
 
 static int copyLink(const struct stat &stBuf, 
-        const shared_ptr<EncFS_Root> &rootInfo,
+        const boost::shared_ptr<EncFS_Root> &rootInfo,
         const string &cpath, const string &destName )
 {
     scoped_array<char> buf(new char[stBuf.st_size+1]);
@@ -494,10 +494,10 @@ static int copyLink(const struct stat &stBuf,
     return EXIT_SUCCESS;
 }
 
-static int copyContents(const shared_ptr<EncFS_Root> &rootInfo, 
+static int copyContents(const boost::shared_ptr<EncFS_Root> &rootInfo, 
                         const char* encfsName, const char* targetName)
 {
-    shared_ptr<FileNode> node = 
+    boost::shared_ptr<FileNode> node = 
 	rootInfo->root->lookupNode( encfsName, "encfsctl" );
 
     if(!node)
@@ -542,7 +542,7 @@ static bool endsWith(const string &str, char ch)
 	return str[str.length()-1] == ch;
 }
 
-static int traverseDirs(const shared_ptr<EncFS_Root> &rootInfo, 
+static int traverseDirs(const boost::shared_ptr<EncFS_Root> &rootInfo, 
 	string volumeDir, string destDir)
 {
     if(!endsWith(volumeDir, '/'))
@@ -554,7 +554,7 @@ static int traverseDirs(const shared_ptr<EncFS_Root> &rootInfo,
     // with the same permissions
     {
         struct stat st;
-        shared_ptr<FileNode> dirNode = 
+        boost::shared_ptr<FileNode> dirNode = 
             rootInfo->root->lookupNode( volumeDir.c_str(), "encfsctl" );
         if(dirNode->getAttr(&st))
             return EXIT_FAILURE;
@@ -622,7 +622,7 @@ static int cmd_export( int argc, char **argv )
     return traverseDirs(rootInfo, "/", destDir);
 }
 
-int showcruft( const shared_ptr<EncFS_Root> &rootInfo, const char *dirName )
+int showcruft( const boost::shared_ptr<EncFS_Root> &rootInfo, const char *dirName )
 {
     int found = 0;
     DirTraverse dt = rootInfo->root->openDir( dirName );
@@ -710,7 +710,7 @@ static int do_chpasswd( bool useStdin, int argc, char **argv )
     }
 
     // instanciate proper cipher
-    shared_ptr<Cipher> cipher = Cipher::New( 
+    boost::shared_ptr<Cipher> cipher = Cipher::New( 
             config->cipherIface, config->keySize );
     if(!cipher)
     {
diff --git a/encfs/main.cpp b/encfs/main.cpp
index 2c17d84..0e5fcad 100644
--- a/encfs/main.cpp
+++ b/encfs/main.cpp
@@ -87,7 +87,7 @@ struct EncFS_Args
     const char *fuseArgv[MaxFuseArgs];
     int fuseArgc;
 
-    shared_ptr<EncFS_Opts> opts;
+    boost::shared_ptr<EncFS_Opts> opts;
 
     // for debugging
     // In case someone sends me a log dump, I want to know how what options are
@@ -183,7 +183,7 @@ string slashTerminate( const string &src )
 }
 
 static 
-bool processArgs(int argc, char *argv[], const shared_ptr<EncFS_Args> &out)
+bool processArgs(int argc, char *argv[], const boost::shared_ptr<EncFS_Args> &out)
 {
     // set defaults
     out->isDaemon = true;
@@ -503,7 +503,7 @@ int main(int argc, char *argv[])
 
     // anything that comes from the user should be considered tainted until
     // we've processed it and only allowed through what we support.
-    shared_ptr<EncFS_Args> encfsArgs( new EncFS_Args );
+    boost::shared_ptr<EncFS_Args> encfsArgs( new EncFS_Args );
     for(int i=0; i<MaxFuseArgs; ++i)
 	encfsArgs->fuseArgv[i] = NULL; // libfuse expects null args..
 
@@ -670,7 +670,7 @@ int main(int argc, char *argv[])
 
     // cleanup so that we can check for leaked resources..
     rootInfo.reset();
-    ctx->setRoot( shared_ptr<DirNode>() );
+    ctx->setRoot( boost::shared_ptr<DirNode>() );
 
     MemoryPool::destroyAll();
     openssl_shutdown( encfsArgs->isThreaded );
@@ -692,7 +692,7 @@ static
 void * idleMonitor(void *_arg)
 {
     EncFS_Context *ctx = (EncFS_Context*)_arg;
-    shared_ptr<EncFS_Args> arg = ctx->args;
+    boost::shared_ptr<EncFS_Args> arg = ctx->args;
 
     const int timeoutCycles = 60 * arg->idleTimeout / ActivityCheckInterval;
     int idleCycles = 0;
@@ -742,13 +742,13 @@ void * idleMonitor(void *_arg)
 
 static bool unmountFS(EncFS_Context *ctx)
 {
-    shared_ptr<EncFS_Args> arg = ctx->args;
+    boost::shared_ptr<EncFS_Args> arg = ctx->args;
     if( arg->opts->mountOnDemand )
     {
 	rDebug("Detaching filesystem %s due to inactivity",
 		arg->mountPoint.c_str());
 
-	ctx->setRoot( shared_ptr<DirNode>() );
+	ctx->setRoot( boost::shared_ptr<DirNode>() );
 	return false;
     } else
     {
diff --git a/encfs/makeKey.cpp b/encfs/makeKey.cpp
index d5e4479..b5b5c2e 100644
--- a/encfs/makeKey.cpp
+++ b/encfs/makeKey.cpp
@@ -31,7 +31,7 @@
 
 using namespace std;
 
-void genKey( const shared_ptr<Cipher> &cipher )
+void genKey( const boost::shared_ptr<Cipher> &cipher )
 {
     CipherKey key = cipher->newRandomKey();
 
@@ -58,7 +58,7 @@ int main(int argc, char **argv)
     openssl_init(false);
 
     // get a list of the available algorithms
-    shared_ptr<Cipher> cipher = Cipher::New( type, size );
+    boost::shared_ptr<Cipher> cipher = Cipher::New( type, size );
     genKey( cipher );
 
     //openssl_shutdown(false);
diff --git a/encfs/test.cpp b/encfs/test.cpp
index ed11b18..10d2a2d 100644
--- a/encfs/test.cpp
+++ b/encfs/test.cpp
@@ -52,12 +52,12 @@ using namespace std;
 using namespace rel;
 using namespace rlog;
 
-using boost::shared_ptr;
+using boost::shared_ptr;
     
 const int FSBlockSize = 256;
 
 static
-int checkErrorPropogation( const shared_ptr<Cipher> &cipher,
+int checkErrorPropogation( const boost::shared_ptr<Cipher> &cipher,
 	int size, int byteToChange, const CipherKey &key )
 {
     MemBlock orig = MemoryPool::allocate(size);
@@ -164,7 +164,7 @@ bool testNameCoding( DirNode &dirNode, bool verbose )
     return true;
 }
 
-bool runTests(const shared_ptr<Cipher> &cipher, bool verbose)
+bool runTests(const boost::shared_ptr<Cipher> &cipher, bool verbose)
 {
     // create a random key
     if(verbose)
@@ -301,7 +301,7 @@ bool runTests(const shared_ptr<Cipher> &cipher, bool verbose)
 	{
 	    // test stream mode, this time without IV chaining
             fsCfg->nameCoding =
-		shared_ptr<NameIO>( new StreamNameIO( 
+		boost::shared_ptr<NameIO>( new StreamNameIO( 
 			    StreamNameIO::CurrentInterface(), cipher, key ) );
             fsCfg->nameCoding->setChainedNameIV( false );
 
@@ -313,7 +313,7 @@ bool runTests(const shared_ptr<Cipher> &cipher, bool verbose)
 
 	{
 	    // test block mode, this time without IV chaining
-            fsCfg->nameCoding = shared_ptr<NameIO>( new BlockNameIO(
+            fsCfg->nameCoding = boost::shared_ptr<NameIO>( new BlockNameIO(
 			BlockNameIO::CurrentInterface(), cipher, key,
 			cipher->cipherBlockSize() ) );
             fsCfg->nameCoding->setChainedNameIV( false );
@@ -480,7 +480,7 @@ int main(int argc, char *argv[])
 	    cerr << it->name << ", key length " << keySize
 		<< ", block size " << blockSize << ":  ";
 
-	    shared_ptr<Cipher> cipher = Cipher::New( it->name, keySize );
+	    boost::shared_ptr<Cipher> cipher = Cipher::New( it->name, keySize );
 	    if(!cipher)
 	    {
 		cerr << "FAILED TO CREATE\n";
@@ -501,7 +501,7 @@ int main(int argc, char *argv[])
     }
 
     // run one test with verbose output too..
-    shared_ptr<Cipher> cipher = Cipher::New("AES", 192);
+    boost::shared_ptr<Cipher> cipher = Cipher::New("AES", 192);
     if(!cipher)
     {
 	cerr << "\nNo AES cipher found, skipping verbose test.\n";
