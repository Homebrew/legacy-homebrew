require 'formula'

class Newsbeuter < Formula
  homepage 'http://newsbeuter.org/'
  url 'http://www.newsbeuter.org/downloads/newsbeuter-2.8.tar.gz'
  sha1 'de284124c840062941b500ffbd72e3f183fb2b61'

  head 'https://github.com/akrennmair/newsbeuter.git'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'json-c'
  depends_on 'libstfl'
  depends_on 'sqlite'

  def install
    if MacOS.version > :mountain_lion and ENV.compiler == :clang
      # see https://github.com/akrennmair/newsbeuter/issues/108
      inreplace [
        'include/regexmanager.h',
        'include/rss.h',
        'rss/rsspp_internal.h'], '<tr1/', '<'

      inreplace [
        'include/cache.h',
        'include/controller.h',
        'include/feedlist_formaction.h',
        'include/formaction.h',
        'include/itemlist_formaction.h',
        'include/itemview_formaction.h',
        'include/regexmanager.h',
        'include/rss.h',
        'include/rss_parser.h',
        'include/view.h',
        'rss/rsspp_internal.h',
        'rss/parser.cpp',
        'rss/parser_factory.cpp',
        'src/cache.cpp',
        'src/controller.cpp',
        'src/feedlist_formaction.cpp',
        'src/formaction.cpp',
        'src/itemlist_formaction.cpp',
        'src/itemview_formaction.cpp',
        'src/regexmanager.cpp',
        'src/rss.cpp',
        'src/rss_parser.cpp',
        'src/view.cpp',
        'test/test.cpp'], 'tr1::', ''

      ENV.append 'CXXFLAGS', '--std=c++11'
    end

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end
end
