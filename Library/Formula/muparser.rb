require 'formula'

class Muparser < Formula
  homepage 'http://muparser.beltoforion.de/'
  url 'https://downloads.sourceforge.net/project/muparser/muparser/Version%202.2.3/muparser_v2_2_3.zip'
  sha1 '3974898052dd9ef350df1860f8292755f78f59df'

  bottle do
    cellar :any
    sha1 "5770d673e9eb9f55504eed8828c23508d1140399" => :mavericks
    sha1 "62a89223d3ae31a0bcc18adb31f5bb9ad570018f" => :mountain_lion
    sha1 "0e10886b7ca3e5c294f7d8e5913e66889f309175" => :lion
  end

  def install
    # patch to correct thousands separator behavior when built against libc++.
    # https://groups.google.com/d/topic/muparser-dev/l8pbPFnR46s/discussion
    # https://code.google.com/p/muparser/source/detail?r=18
    inreplace 'include/muParserBase.h', 'std::string(1, m_nGroup)', 'std::string(1, (char)(m_cThousandsSep > 0 ? m_nGroup : CHAR_MAX))'
    inreplace 'include/muParserInt.h', 'std::string(1, m_nGroup)', 'std::string(1, (char)(m_cThousandsSep > 0 ? m_nGroup : CHAR_MAX))'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
