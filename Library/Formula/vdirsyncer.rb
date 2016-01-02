class Vdirsyncer < Formula
  desc "Synchronize calendars and contacts"
  homepage "https://github.com/untitaker/vdirsyncer"
  url "https://pypi.python.org/packages/source/v/vdirsyncer/vdirsyncer-0.7.3.tar.gz"
  sha256 "3e87df25f7f5af172f2063e39deccac7c5477a2be3c7ff16183b6b8e9f2d112a"
  head "https://github.com/untitaker/vdirsyncer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "074aadb17cfe961bb81842fc7391db12e3d2e4bd44690479d7535d3bc2c1cbbc" => :el_capitan
    sha256 "1068d4515c5b9fa951dac43c9fb10fc7b7a33ab1252ef2d1547de2504da6b1bb" => :yosemite
    sha256 "6c5d879d6a338b6fb05cc3800cff22aa8e91c402dc1d0288e6ce6f94606474a7" => :mavericks
  end

  option "without-keyring", "Build without python-keyring support"

  depends_on :python3

  resource "keyring" do
    url "https://pypi.python.org/packages/source/k/keyring/keyring-5.4.tar.gz"
    sha256 "45891cd0af4c4af70fbed7ec6e3964d0261c14188de9ab31030c9d02272e22d2"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-5.1.tar.gz"
    sha256 "678c98275431fad324275dec63791e4a17558b40e5a110e20a82866139a85a5a"
  end

  resource "click_threading" do
    url "https://pypi.python.org/packages/source/c/click-threading/click-threading-0.1.2.tar.gz"
    sha256 "85045457e02f16fba3110dc6b16e980bf3e65433808da2b550dd513206d9b94a"
  end

  resource "click_log" do
    url "https://pypi.python.org/packages/source/c/click-log/click-log-0.1.1.tar.gz"
    sha256 "0bc7e69311007adc4b5304d47933761999a43a18a87b9b7f2aa12b5e256f72fc"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.4.4.tar.gz"
    sha256 "b3d362bac471172747cda3513238f115cbd6c5f8b8e6319bf6a97a7892724099"
  end

  resource "requests-toolbelt" do
    url "https://pypi.python.org/packages/source/r/requests-toolbelt/requests-toolbelt-0.4.0.tar.gz"
    sha256 "15b74b90a63841b8430d6301e5062cd92929b1074b0c95bf62166b8239db1a96"
  end

  resource "atomicwrites" do
    url "https://pypi.python.org/packages/source/a/atomicwrites/atomicwrites-0.1.5.tar.gz"
    sha256 "9b16a8f1d366fb550f3d5a5ed4587022735f139a4187735466f34cf4577e4eaa"
  end

  def install
    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"
    rs = %w[click click_threading click_log requests lxml requests-toolbelt atomicwrites]
    rs << "keyring" if build.with? "keyring"
    rs.each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"
    (testpath/".config/vdirsyncer/config").write <<-EOS.undent
      [general]
      status_path = #{testpath}/.vdirsyncer/status/
      [pair contacts]
      a = contacts_a
      b = contacts_b
      collections = ["from a"]
      [storage contacts_a]
      type = filesystem
      path = ~/.contacts/a/
      fileext = .vcf
      [storage contacts_b]
      type = filesystem
      path = ~/.contacts/b/
      fileext = .vcf
    EOS
    (testpath/".contacts/a/foo/092a1e3b55.vcf").write <<-EOS.undent
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    (testpath/".contacts/b/foo/").mkpath
    system "#{bin}/vdirsyncer", "sync"
    assert_match /BEGIN:VCARD/, (testpath/".contacts/b/foo/092a1e3b55.vcf").read
  end
end
