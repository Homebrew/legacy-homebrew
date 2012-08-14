require 'formula'

class Mp4v2 < Formula
  homepage 'http://code.google.com/p/mp4v2/'
  url 'http://mp4v2.googlecode.com/files/mp4v2-1.9.1.tar.bz2'
  sha1 'c62d00e99b65efce16accd83c501fb8a57206aa8'

  devel do
    url 'http://mp4v2.googlecode.com/files/mp4v2-trunk-r479.tar.bz2'
    sha1 '1999b805d5e66dffbd95ec3a563758650e23bf60'
    version 'r479'
  end

  def patches
    # Fixes compile error on Lion w/Clang using a patch from svn:
    # http://code.google.com/p/mp4v2/source/detail?r=442
    # It is inline because there's no direct link to the raw patch.
    DATA unless ARGV.build_devel?
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "make install-man"
  end
end

__END__
--- a/src/bmff/typebmff.cpp	2009-07-13 16:07:10.000000000 -0700
+++ b/src/bmff/typebmff.cpp	2012-03-28 11:05:48.000000000 -0700
@@ -23,19 +23,12 @@
 
 #include "impl.h"
 
-// VStudio idiocy prevents defining template instanced static data
-// in a namespace. Workaround it by defining in global scope.
-// Other platforms will continue to put things in the proper namespace.
-#if defined( _MSC_VER )
-using namespace mp4v2::impl::bmff;
-#else
-namespace mp4v2 { namespace impl { namespace bmff {
-#endif
+namespace mp4v2 { namespace impl {
 
 ///////////////////////////////////////////////////////////////////////////////
 
 template <>
-const EnumLanguageCode::Entry EnumLanguageCode::data[] = {
+const bmff::EnumLanguageCode::Entry bmff::EnumLanguageCode::data[] = {
     { mp4v2::impl::bmff::ILC_AAR,  "aar",  "Afar" },
     { mp4v2::impl::bmff::ILC_ABK,  "abk",  "Abkhazian" },
     { mp4v2::impl::bmff::ILC_ACE,  "ace",  "Achinese" },
@@ -526,9 +519,7 @@
 
 ///////////////////////////////////////////////////////////////////////////////
 
-#if defined( _MSC_VER )
-namespace mp4v2 { namespace impl { namespace bmff {
-#endif
+namespace bmff {
 
 ///////////////////////////////////////////////////////////////////////////////
 
--- a/src/itmf/type.cpp	2009-07-13 16:07:08.000000000 -0700
+++ b/src/itmf/type.cpp	2012-03-28 11:30:25.000000000 -0700
@@ -24,19 +24,12 @@
 
 #include "impl.h"
 
-// VStudio idiocy prevents defining template instanced static data
-// in a namespace. Workaround it by defining in global scope.
-// Other platforms will continue to put things in the proper namespace.
-#if defined( _MSC_VER )
-using namespace mp4v2::impl::itmf;
-#else
-namespace mp4v2 { namespace impl { namespace itmf {
-#endif
+namespace mp4v2 { namespace impl {
 
 ///////////////////////////////////////////////////////////////////////////////
 
 template <>
-const EnumBasicType::Entry EnumBasicType::data[] = {
+const itmf::EnumBasicType::Entry itmf::EnumBasicType::data[] = {
     { mp4v2::impl::itmf::BT_IMPLICIT,  "implicit",  "implicit" },
     { mp4v2::impl::itmf::BT_UTF8,      "utf8",      "UTF-8" },
     { mp4v2::impl::itmf::BT_UTF16,     "utf16",     "UTF-16" },
@@ -64,7 +57,7 @@
 ///////////////////////////////////////////////////////////////////////////////
 
 template <>
-const EnumGenreType::Entry EnumGenreType::data[] = {
+const itmf::EnumGenreType::Entry itmf::EnumGenreType::data[] = {
     { mp4v2::impl::itmf::GENRE_BLUES,             "blues",             "Blues" },
     { mp4v2::impl::itmf::GENRE_CLASSIC_ROCK,      "classicrock",       "Classic Rock" },
     { mp4v2::impl::itmf::GENRE_COUNTRY,           "country",           "Country" },
@@ -200,7 +193,7 @@
 ///////////////////////////////////////////////////////////////////////////////
 
 template <>
-const EnumStikType::Entry EnumStikType::data[] = {
+const itmf::EnumStikType::Entry itmf::EnumStikType::data[] = {
     { mp4v2::impl::itmf::STIK_OLD_MOVIE,    "oldmovie",    "Movie" },
     { mp4v2::impl::itmf::STIK_NORMAL,       "normal",      "Normal" },
     { mp4v2::impl::itmf::STIK_AUDIOBOOK,    "audiobook",   "Audio Book" },
@@ -216,7 +209,7 @@
 ///////////////////////////////////////////////////////////////////////////////
 
 template <>
-const EnumAccountType::Entry EnumAccountType::data[] = {
+const itmf::EnumAccountType::Entry itmf::EnumAccountType::data[] = {
     { mp4v2::impl::itmf::AT_ITUNES,  "itunes",   "iTunes" },
     { mp4v2::impl::itmf::AT_AOL,     "aol",      "AOL" },
 
@@ -226,7 +219,7 @@
 ///////////////////////////////////////////////////////////////////////////////
 
 template <>
-const EnumCountryCode::Entry EnumCountryCode::data[] = {
+const itmf::EnumCountryCode::Entry itmf::EnumCountryCode::data[] = {
     { mp4v2::impl::itmf::CC_USA,  "usa",   "United States" },
     { mp4v2::impl::itmf::CC_USA,  "fra",   "France" },
     { mp4v2::impl::itmf::CC_DEU,  "ger",   "Germany" },
@@ -256,7 +249,7 @@
 ///////////////////////////////////////////////////////////////////////////////
 
 template <>
-const EnumContentRating::Entry EnumContentRating::data[] = {
+const itmf::EnumContentRating::Entry itmf::EnumContentRating::data[] = {
     { mp4v2::impl::itmf::CR_NONE,      "none",       "None" },
     { mp4v2::impl::itmf::CR_CLEAN,     "clean",      "Clean" },
     { mp4v2::impl::itmf::CR_EXPLICIT,  "explicit",   "Explicit" },
@@ -266,9 +259,7 @@
 
 ///////////////////////////////////////////////////////////////////////////////
 
-#if defined( _MSC_VER )
-namespace mp4v2 { namespace impl { namespace itmf {
-#endif
+namespace itmf {
 
 ///////////////////////////////////////////////////////////////////////////////
 
