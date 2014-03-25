require 'formula'

class Scala < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/files/archive/scala-2.10.4.tgz'
  sha1 '970f779f155719838e81a267a7418a958fd4c13f'

  devel do
    url 'http://downloads.typesafe.com/scala/2.11.0-RC1/scala-2.11.0-RC1.tgz'
    sha1 '1b8f9149015b4f017e1e295bd187ed726a416437'
    version '2.11.0-RC1'

    resource 'docs' do
      url 'http://downloads.typesafe.com/scala/2.11.0-RC1/scala-docs-2.11.0-RC1.zip'
      sha1 '15411722b67a87186b87ceb61289d3a1a69b725e'
      version '2.11.0-RC1'
    end
  end

  option 'with-docs', 'Also install library documentation'

  resource 'docs' do
    url 'http://www.scala-lang.org/files/archive/scala-docs-2.10.4.zip'
    sha1 '7ad47f9634fd2f452cadf35f7241102207c1a1cc'
  end

  resource 'completion' do
    url 'https://raw.github.com/scala/scala-dist/27bc0c25145a83691e3678c7dda602e765e13413/completion.d/2.9.1/scala'
    sha1 'e2fd99fe31a9fb687a2deaf049265c605692c997'
  end

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir['doc/*']
    man1.install Dir['man/man1/*']
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]

    bash_completion.install resource('completion')

    if build.with? 'docs'
      branch = build.stable? ? 'scala-2.10' : 'scala-2.11'
      (share/'doc'/branch).install resource('docs')
    end

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/'idea'
    idea.install_symlink libexec/'src', libexec/'lib'
    (idea/'doc/scala-devel-docs').install_symlink doc => 'api'
  end

  def caveats; <<-EOS.undent
    To use with IntelliJ, set the Scala home to:
      #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/'hello.scala'
    file.write <<-EOS.undent
      object Computer {
        def main(args: Array[String]) {
          println(2 + 2)
        }
      }
    EOS
    output = `'#{bin}/scala' #{file}`
    assert_equal "4", output.strip
    assert $?.success?
  end
end
