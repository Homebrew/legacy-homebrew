class Fdroidserver < Formula
  desc "Create and manage Android app repositories for F-Droid"
  homepage "https://f-droid.org/"
  url "https://pypi.python.org/packages/source/f/fdroidserver/fdroidserver-0.4.0.tar.gz"
  sha256 "89742f2e03e082c9d185835dbb4f166dade19a0e257b247a6e0bca3b4fd9b523"

  bottle do
    cellar :any
    sha256 "ee2b8c9ce88c44da4949297dbf02e1d8a959626ae04ec35ac27a213fc6f14cff" => :el_capitan
    sha256 "c022c4b821fc08ebc7bcdf0dd55f393bffff60fc8d9124d1f3bbedfda2b1b476" => :yosemite
    sha256 "b82b7afb81d63e8a734111d9ebf86079cdcd9c60903c03f0057b281709af7aef" => :mavericks
  end

  depends_on :java => "1.7+"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libyaml"
  depends_on "android-sdk" => :recommended
  depends_on "libmagic" => :recommended

  resource "apache-libcloud" do
    url "https://pypi.python.org/packages/source/a/apache-libcloud/apache-libcloud-0.17.0.tar.gz"
    sha256 "8ac4895c5ed2fa51812237dfd587675e3cbc4b7e57d9b44722ce849eab2131c2"
  end

  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  resource "mwclient" do
    url "https://pypi.python.org/packages/source/m/mwclient/mwclient-0.7.2.zip"
    sha256 "195462115fadbe3cee73b5a0fe3cc28c8bdc0115c590cdc0f8b5083861003d1a"
  end

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.2.tar.gz"
    sha256 "4f56a671a3eecbb76e6143e6e4ca007d503a39aa79aa9e14ade667fa53fd6e55"
  end

  resource "pillow" do
    url "https://pypi.python.org/packages/source/P/Pillow/Pillow-2.9.0.tar.gz"
    sha256 "0f179d7e75e7c83b6341b9595ca1f394de7081484a9e352ad66d553a1c3daa29"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.7.tar.gz"
    sha256 "e4f81d53c533f6bd9526b047f047f7b101c24ab17339c1a7ad8f98b25c101eab"
  end

  resource "pyasn1-modules" do
    url "https://pypi.python.org/packages/source/p/pyasn1-modules/pyasn1-modules-0.0.5.tar.gz"
    sha256 "be65f00ed28e30756f1ef39377cb382480a2368699179d646a84d79fe9349941"
  end

  resource "python-magic" do
    url "https://pypi.python.org/packages/source/p/python-magic/python-magic-0.4.6.tar.gz"
    sha256 "903d3d3c676e2b1244892954e2bbbe27871a633385a9bfe81f1a81a7032df2fe"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  def install
    ENV["PYTHONPATH"] = Formula["libdnet"].opt_lib/"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.append_to_cflags "-I#{Formula["freetype"].opt_include}/freetype2"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    In order to function, fdroidserver requires that the Android SDK's
    "Build-tools" and "Platform-tools" are installed.  Also, it is best if the
    base path of the Android SDK is set in the standard environment variable
    ANDROID_HOME.  To install them from the command line, run:
    android update sdk --no-ui --all --filter platform-tools,build-tools-23.0.1
    EOS
  end

  test do
    # fdroid prefers to work in a dir called 'fdroid'
    mkdir testpath/"fdroid" do
      mkdir "repo"
      mkdir "metadata"

      open("config.py", "w") do |f|
        f << "gradle = 'gradle'"
      end

      open("metadata/fake.txt", "w") do |f|
        f << "License:GPL\n"
        f << "Summary:Yup still fake\n"
        f << "Categories:Internet\n"
        f << "Description:\n"
        f << "this is fake\n"
        f << ".\n"
      end

      system "#{bin}/fdroid", "checkupdates", "--verbose"
      system "#{bin}/fdroid", "lint", "--verbose"
      system "#{bin}/fdroid", "rewritemeta", "fake", "--verbose"
      system "#{bin}/fdroid", "scanner", "--verbose"

      # TODO: enable once Android SDK build-tools are reliably installed
      # ENV["ANDROID_HOME"] = Formula["android-sdk"].opt_prefix
      # system "#{bin}/fdroid", "readmeta", "--verbose"
      # system "#{bin}/fdroid", "init", "--verbose"
      # assert File.exist?("config.py")
      # assert File.exist?("keystore.jks")
      # system "#{bin}/fdroid", "update", "--create-metadata", "--verbose"
      # assert File.exist?("metadata")
      # assert File.exist?("repo/index.jar")
    end
  end
end
