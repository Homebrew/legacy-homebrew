require 'formula'

class WdgHtmlValidator < Formula
  homepage 'https://github.com/robinhouston/wdg-html-validator'
  url 'https://github.com/downloads/robinhouston/wdg-html-validator/wdg-html-validator.tgz'
  md5 '30cadd2e5d85d9e2c310c3f9392859a6'
  version '1.6.2-7'

  depends_on 'open-sp'

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def test
    mktemp do
      Pathname.new("test.html").write <<-END.undent
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
                "http://www.w3.org/TR/html4/strict.dtd">
        <HTML>
          <HEAD>
            <TITLE>The document title</TITLE>
          </HEAD>
          <BODY>
            <H1>Main heading</H1>
            <P>A paragraph.</P>
            <P>Another paragraph.</P>
            <UL>
              <LI>A list item.</LI>
              <LI>Another list item.</LI>
            </UL>
          </BODY>
        </HTML>
      END
      system "validate", "test.html"
    end
  end
end
