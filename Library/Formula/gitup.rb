class Gitup < Formula
  desc "Update multiple git repositories at once"
  homepage "https://github.com/earwig/git-repo-updater"
  url "https://github.com/earwig/git-repo-updater.git",
    :revision => "10494e677bba19622acfa3fc62093a06451c8562",
    :tag => "v0.3"

  bottle do
    cellar :any
    sha256 "9467012a786daf151c8753b6fea2003749696a8c790df3230e04041cbc5f8ef3" => :yosemite
    sha256 "e549ee12a5faa4cd5bf2ffe5b5d745a1186da9f87df186676a37df60e64a419d" => :mavericks
    sha256 "3ea5f1c672e777fe044bc1bc3242e82583ee3db7dbf050ff42a926a1fda7128f" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "smmap" do
    url "https://pypi.python.org/packages/source/s/smmap/smmap-0.9.0.tar.gz"
    sha256 "0e2b62b497bd5f0afebc002eda4d90df9d209c30ef257e8673c90a6b5c119d62"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.3.tar.gz"
    sha256 "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c"
  end

  resource "gitdb" do
    url "https://pypi.python.org/packages/source/g/gitdb/gitdb-0.6.4.tar.gz"
    sha256 "a3ebbc27be035a2e874ed904df516e35f4a29a778a764385de09de9e0f139658"
  end

  resource "GitPython" do
    url "https://pypi.python.org/packages/source/G/GitPython/GitPython-1.0.1.tar.gz"
    sha256 "9c88c17bbcae2a445ff64024ef13526224f70e35e38c33416be5ceb56ca7f760"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[smmap colorama gitdb GitPython].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    def prepare_repo(uri, local_head)
      system "git", "init"
      system "git", "remote", "add", "origin", uri
      system "git", "fetch", "origin"
      system "git", "checkout", local_head
      system "git", "reset", "--hard"
      system "git", "checkout", "-b", "master"
      system "git", "branch", "--set-upstream-to=origin/master", "master"
    end

    first_head_start = "f47ab45abdbc77e518776e5dc44f515721c523ae"
    mkdir "first" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-contrib.git", first_head_start)
    end

    second_head_start = "f863d5ca9e39e524e8c222428e14625a5053ed2b"
    mkdir "second" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-cask-games.git", second_head_start)
    end

    system "gitup", "first", "second"

    first_head = `cd first ; git rev-parse HEAD`.split.first
    assert_not_equal first_head, first_head_start

    second_head = `cd second ; git rev-parse HEAD`.split.first
    assert_not_equal second_head, second_head_start

    third_head_start = "f47ab45abdbc77e518776e5dc44f515721c523ae"
    mkdir "third" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-contrib.git", third_head_start)
    end

    system "gitup", "--add", "third"

    system "gitup"
    third_head = `cd third ; git rev-parse HEAD`.split.first
    assert_not_equal third_head, third_head_start

    assert_match %r{#{Dir.pwd}/third}, `gitup --list`.strip

    system "gitup", "--delete", "#{Dir.pwd}/third"
  end
end
