class Khard < Formula
  homepage "https://github.com/scheibler/khard/"
  desc "Console carddav client."
  url "https://pypi.python.org/packages/source/k/khard/khard-0.8.1.tar.gz"
  sha256 "00324a0faf87d8ca80be0a24e7d84a5faf763af3146565ac6b57db8a49d20f25"

  bottle do
    cellar :any_skip_relocation
    sha256 "be3fda519b336bdff13313ad034c8dd966d7cb66cae4f19eb0802ab63f8b278c" => :el_capitan
    sha256 "00965208aae17f82402f9d7d61b794dd06f6eb6e87e96e14c4bb3f2ba57f46c4" => :yosemite
    sha256 "e471e4eb7a6966939ea90df23810e0d63b40e197228a0c97596045b6217bd652" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "atomicwrites" do
    url "https://pypi.python.org/packages/source/a/atomicwrites/atomicwrites-0.1.9.tar.gz"
    sha256 "7cdfcee8c064bc0ba30b0444ba0919ebafccf5b0b1916c8cde07e410042c4023"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.5.0.tar.gz"
    sha256 "c1f7a66b0021bd7b206cc60dd47ecc91b931cdc5258972dc56b25186fa9a96a5"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "vobject" do
    url "https://pypi.python.org/packages/source/v/vobject/vobject-0.9.1.tar.gz"
    sha256 "ff25fd924227c4ef9369cfd731e486ccae988a9bc32d1e4417cfa7dcb2959fb3"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[atomicwrites configobj python-dateutil PyYAML six vobject].each do |r|
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
