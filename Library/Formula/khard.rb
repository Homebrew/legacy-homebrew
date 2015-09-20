class Khard < Formula
  desc "Console carddav client."
  homepage "https://github.com/scheibler/khard"
  url "https://pypi.python.org/packages/source/k/khard/khard-0.5.0.tar.gz"
  sha256 "6880a639a32a2830b2d62f70d7f0155216fa2f6d599d8b8bb6b45c1df912e3bf"

  bottle do
    cellar :any
    sha256 "6426f3311fd328c594b082a749cd77af5442d0694a99536169c73736281bd557" => :yosemite
    sha256 "56450b1766631735ae82133ae47708e87abaf78b71873f34475893b581a7a1ad" => :mavericks
    sha256 "04e2c3984ef778222aaf231ae84c9f40c6625541bc4ee1c095536f170e619301" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "vobject" do
    url "https://pypi.python.org/packages/source/v/vobject/vobject-0.8.1c.tar.gz"
    sha256 "594113117f2017ed837c8f3ce727616f9053baa5a5463a7420c8249b8fc556f5"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.3.0.tar.gz"
    sha256 "b3a79a23d37b5a02faa550b92cbbbebeb4aa1d77e649c3eb39c19abf5262da04"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[vobject configobj argparse six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/".config/khard/khard.conf").write <<-EOS.undent
      [addressbooks]
      [[default]]
      path = ~/.contacts/
      [general]
      editor = /usr/bin/vi
      merge_editor = /usr/bin/vi
      default_country = Germany
      default_action = list
      show_nicknames = yes
    EOS
    (testpath/".contacts/dummy.vcf").write <<-EOS.undent
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    assert_match /Address book: default/, shell_output("#{bin}/khard -s user", 0)
  end
end
