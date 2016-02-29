class AwsShell < Formula
  desc "Integrated shell for working with the AWS CLI."
  homepage "https://github.com/awslabs/aws-shell"
  url "https://pypi.python.org/packages/source/a/aws-shell/aws-shell-0.1.0.tar.gz"
  sha256 "2d89e3c51e6cf7da74c8bca8b8a986cc8edcad27ccd6c15678cd84b970f63a16"

  head do
    url "https://github.com/awslabs/aws-shell.git"

    resource "awscli" do
      url "https://github.com/aws/aws-cli.git", :branch => "develop"
    end

    resource "boto3" do
      url "https://github.com/boto/boto3.git", :branch => "develop"
    end

    resource "botocore" do
      url "https://github.com/boto/botocore.git", :branch => "develop"
    end

    resource "colorama" do
      url "https://github.com/tartley/colorama.git",
      :tag => "v0.3.3",
      :revision => "5906b2604223f3a3bdf4497244fc8861b89dbda6"
    end

    resource "configobj" do
      url "https://github.com/DiffSK/configobj.git", :branch => "release"
    end

    resource "docutils" do
      url "https://github.com/chevah/docutils.git", :branch => "docutils-0.12-chevah"
    end

    resource "jmespath" do
      url "https://github.com/boto/jmespath.git", :branch => "develop"
    end

    resource "python-dateutil" do
      url "https://github.com/dateutil/dateutil.git",
      :tag => "2.4.2",
      :revision => "248106da8e5f4023210d7a18d30b176577916b4f"
    end

    resource "rsa" do
      url "https://github.com/sybrenstuvel/python-rsa.git"
    end

    resource "s3transfer" do
      url "https://github.com/boto/s3transfer.git", :branch => "develop"
    end

    resource "wcwidth" do
      url "https://github.com/jquast/wcwidth.git"
    end
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  resource "awscli" do
    url "https://pypi.python.org/packages/source/a/awscli/awscli-1.10.1.tar.gz"
    sha256 "6b738f7fc6af7ab9c759b7efb5decde71970990061b2df169b14bec89c452c95"
  end

  resource "boto3" do
    url "https://pypi.python.org/packages/source/b/boto3/boto3-1.2.1.tar.gz"
    sha256 "6a642af0a5cce1bfee4b1a829bdfbb3a7e9feffb8175426c8726465b8d2e4fae"
  end

  resource "botocore" do
    url "https://pypi.python.org/packages/source/b/botocore/botocore-1.3.23.tar.gz"
    sha256 "d2e067bdb3e9b5c26821efc8517a9ced4f9d5f4cd30de14585ed1fe0eb552a02"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.3.tar.gz"
    sha256 "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/source/f/futures/futures-2.2.0.tar.gz"
    sha256 "151c057173474a3a40f897165951c0e33ad04f37de65b6de547ddef107fd0ed3"
  end

  resource "jmespath" do
    url "https://pypi.python.org/packages/source/j/jmespath/jmespath-0.9.0.tar.gz"
    sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
  end

  resource "prompt_toolkit" do
    url "https://pypi.python.org/packages/source/p/prompt_toolkit/prompt_toolkit-0.52.tar.gz"
    sha256 "35b8a34df8dea4cba92222dc1b8700c30ed7a8ba47cf3bc583768c5571a30902"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.1.tar.gz"
    sha256 "13a0ef5fafd7b16cf995bc28fe7aab0780dab1b2fda0fc89e033709af8b8a47b"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "rsa" do
    url "https://pypi.python.org/packages/source/r/rsa/rsa-3.2.3.tar.gz"
    sha256 "14db288cc40d6339dedf60d7a47053ab004b4a8976a5c59402a211d8fc5bf21f"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "s3transfer" do
    url "https://pypi.python.org/packages/source/s/s3transfer/s3transfer-0.0.1.tar.gz"
    sha256 "990322078da427c405e24ddfd937947a0370488c12f5f1b9bac632fa82f97a18"
  end

  resource "wcwidth" do
    url "https://pypi.python.org/packages/source/w/wcwidth/wcwidth-0.1.6.tar.gz"
    sha256 "dcb3ec4771066cc15cf6aab5d5c4a499a5f01c677ff5aeb46cf20500dccd920b"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/aws-shell", "--help"
  end
end
