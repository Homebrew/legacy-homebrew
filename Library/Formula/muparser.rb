require 'formula'

class Muparser < Formula
  homepage 'http://muparser.beltoforion.de/'
  url 'https://downloads.sourceforge.net/project/muparser/muparser/Version%202.2.3/muparser_v2_2_3.zip'
  sha1 '3974898052dd9ef350df1860f8292755f78f59df'

  bottle do
    cellar :any
    revision 1
    sha1 "138dd0da70ef47470e5f19b0261dc357d1734afd" => :mavericks
    sha1 "dcec9427dff9d1021281ebf0eb8ca22c3877e355" => :mountain_lion
    sha1 "95b0c1e1b228216c712f78892488db996d11ed30" => :lion
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
