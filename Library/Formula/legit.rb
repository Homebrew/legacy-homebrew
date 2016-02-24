class Legit < Formula
  desc "Command-line interface for Git, optimized for workflow simplicity"
  homepage "http://www.git-legit.org/"
  head "https://github.com/kennethreitz/legit.git", :branch => "develop"
  revision 1

  stable do
    url "https://github.com/kennethreitz/legit/archive/v0.2.0.tar.gz"
    sha256 "dce86a16d9c95e2a7d93be75f1fc17c67d3cd2a137819fa498e179bf21daf39e"

    # Merged in HEAD; remove in next stable release
    patch do
      url "https://github.com/kennethreitz/legit/commit/610faf46b7b340e5233187c75cd83f7c1bf1999e.diff"
      sha256 "7958433a5d594b8a982825ef4af1050f6f00b8bfb79fbed7e099be844403a3cd"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha256 "1730b03f14976f54108a63fdd880c916ff3d0ce0624c594dba1d886ae63e200a" => :yosemite
    sha256 "ed1637ede4f8e5b5a4abc3d77c159b036501aa94ea0f560582ec77e312135556" => :mavericks
    sha256 "72416a4f9d0ebbb0b61bd2573269dd0662a72b00d377e3642ce2ad82e6c8272e" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "clint" do
    url "https://pypi.python.org/packages/source/c/clint/clint-0.4.1.tar.gz"
    sha256 "3a9e7ba7ceaa10276bcfe85110a04633813344406ec6181063cd79210b2804a8"
  end

  resource "args" do
    url "https://pypi.python.org/packages/source/a/args/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "GitPython" do
    url "https://pypi.python.org/packages/source/G/GitPython/GitPython-1.0.1.tar.gz"
    sha256 "9c88c17bbcae2a445ff64024ef13526224f70e35e38c33416be5ceb56ca7f760"
  end

  resource "gitdb" do
    url "https://pypi.python.org/packages/source/g/gitdb/gitdb-0.6.4.tar.gz"
    sha256 "a3ebbc27be035a2e874ed904df516e35f4a29a778a764385de09de9e0f139658"
  end

  resource "smmap" do
    url "https://pypi.python.org/packages/source/s/smmap/smmap-0.9.0.tar.gz"
    sha256 "0e2b62b497bd5f0afebc002eda4d90df9d209c30ef257e8673c90a6b5c119d62"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    bash_completion.install "extra/bash-completion/legit"
    zsh_completion.install "extra/zsh-completion/_legit"
    man1.install "extra/man/legit.1"
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "init"
    system "git", "remote", "add", "origin", "https://github.com/git/git.git"
    system "#{bin}/legit", "sprout", "test"
    assert_match(/test/, shell_output("#{bin}/legit branches"))
  end
end
