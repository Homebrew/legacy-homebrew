class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/archive/v3.2.2.tar.gz"
  sha256 "5fe5c115e277a9dd616b1077f89bffdf978bc6983ce62d99af9a218142c39e40"
  head "https://github.com/dimitri/pgloader.git"

  bottle do
    sha256 "552a515720eaa8ac645c9c0ada47f7b670dff2b3ee8443bc8ffb0d2d18f474a4" => :el_capitan
    sha256 "2bcb60b7017af6bd821185c91e73bda746f1355ecbb6f777c0f106097c64edcf" => :yosemite
    sha256 "a0f2366fad76983674ef1f086544bd8d329cf1e7bd6fb1b713bc56cb6cd0fff4" => :mavericks
  end

  depends_on "sbcl"
  depends_on "freetds"
  depends_on "buildapp" => :build
  depends_on :postgresql => :recommended

  # Resource stanzas are generated automatically by quicklisp-roundup.
  # See: https://github.com/benesch/quicklisp-homebrew-roundup

  resource "alexandria" do
    url "https://beta.quicklisp.org/archive/alexandria/2015-05-05/alexandria-20150505-git.tgz"
    sha256 "14edf05fd7550a49450c4cdab8a29d2266d722e856e1dd15e3403854d2a633fc"
  end

  resource "anaphora" do
    url "https://beta.quicklisp.org/archive/anaphora/2011-06-19/anaphora-0.9.4.tgz"
    sha256 "5e7334e0b498cf4c01cf767f6f7e2be6a01895cc6f80d7fcae6d311fee43983f"
  end

  resource "asdf-finalizers" do
    url "https://beta.quicklisp.org/archive/asdf-finalizers/2015-06-08/asdf-finalizers-20150608-git.tgz"
    sha256 "2f1d76bea6831ca3873762f2245529db38e8633caa76bd8e15882fbeaf0e1c7f"
  end

  resource "asdf-system-connections" do
    url "https://beta.quicklisp.org/archive/asdf-system-connections/2014-02-11/asdf-system-connections-20140211-git.tgz"
    sha256 "df8bf8fcb0f33535137dfb232183387bef63ae713820c7305d921e5fad9a9669"
  end

  resource "babel" do
    url "https://beta.quicklisp.org/archive/babel/2015-06-08/babel-20150608-git.tgz"
    sha256 "6536bb4b426464151dfa476495bede44da5d67165e8d1179238ce731e6e1625b"
  end

  resource "bordeaux-threads" do
    url "https://beta.quicklisp.org/archive/bordeaux-threads/2013-06-15/bordeaux-threads-0.8.3.tgz"
    sha256 "1e96b51770d9a4a52d1a60b821c2d1807a08b7eb3359a0d1a38349d2353e7630"
  end

  resource "cffi" do
    url "https://beta.quicklisp.org/archive/cffi/2015-09-23/cffi_0.16.1.tgz"
    sha256 "8c0d8ccef43c5cc8562b03f3c3020464578a7c92273cde1060e8d9d89c0ccb47"
  end

  resource "chipz" do
    url "https://beta.quicklisp.org/archive/chipz/2015-05-05/chipz-20150505-git.tgz"
    sha256 "803d15e7a4acdae9e6fd18aaad78abb3bb9681d03a8ebb20ae0f733b06691924"
  end

  resource "chunga" do
    url "https://beta.quicklisp.org/archive/chunga/2014-12-17/chunga-1.1.6.tgz"
    sha256 "efd3a4a1272cc8c04a0875967175abc65e99ff43a5ca0bad12f74f0953746dc7"
  end

  resource "cl+ssl" do
    url "https://beta.quicklisp.org/archive/cl+ssl/2015-06-08/cl+ssl-20150608-git.tgz"
    sha256 "6d7314a13874ad8edbb3bb4ba64344f22b1fee26ffd3280b4e3e02b28cb811e5"
  end

  resource "cl-abnf" do
    url "https://beta.quicklisp.org/archive/cl-abnf/2015-06-08/cl-abnf-20150608-git.tgz"
    sha256 "0799bfdc43b7c645934af8c190e58d4d0fac3973ec669ef2feeae0b20f2ca903"
  end

  resource "cl-base64" do
    url "https://beta.quicklisp.org/archive/cl-base64/2015-09-23/cl-base64-20150923-git.tgz"
    sha256 "17fab703f316d232b477bd2f8b521283cc0c7410f9b787544f3924007ab95141"
  end

  resource "cl-containers" do
    url "https://beta.quicklisp.org/archive/cl-containers/2015-09-23/cl-containers-20150923-git.tgz"
    sha256 "9f02adedb39b4cab31047af7153ee46626009a8305d6fe10b79ccf3d2dd77e66"
  end

  resource "cl-csv" do
    url "https://beta.quicklisp.org/archive/cl-csv/2015-06-08/cl-csv-20150608-git.tgz"
    sha256 "b6a1db0a10937dd1e38247eee2b4aa055a4ca4a65eb93b752a1a2f3d21e02833"
  end

  resource "cl-db3" do
    url "https://beta.quicklisp.org/archive/cl-db3/2015-03-02/cl-db3-20150302-git.tgz"
    sha256 "b1ffd5c0d0e3eca1a505e20e0c4e888a2ec87f37faa9f1fc62adefc6ceba8d57"
  end

  resource "cl-fad" do
    url "https://beta.quicklisp.org/archive/cl-fad/2014-12-17/cl-fad-0.7.3.tgz"
    sha256 "7fce0593d246463ee42029c3a769ca7f0e8538a4d46c82a26b8fac0b9fe23457"
  end

  resource "cl-interpol" do
    url "https://beta.quicklisp.org/archive/cl-interpol/2010-10-06/cl-interpol-0.2.1.tgz"
    sha256 "7b659ecd994f0a2b4d13f698bf1c7afde9c49f579513d59ed576c6e862d7ca66"
  end

  resource "cl-ixf" do
    url "https://beta.quicklisp.org/archive/cl-ixf/2014-08-26/cl-ixf-20140826-git.tgz"
    sha256 "14c6db515cdb1b34859ef5fde4d3539b27a666938de25a036aee51ec72a4f627"
  end

  resource "cl-log" do
    url "https://beta.quicklisp.org/archive/cl-log/2013-01-28/cl-log.1.0.1.tgz"
    sha256 "4d7840b9e3bf5a979f780ba937f4e268c73db48e2f91f6c7c541d86e3ac0ab71"
  end

  resource "cl-markdown" do
    url "https://beta.quicklisp.org/archive/cl-markdown/2010-10-06/cl-markdown-20101006-darcs.tgz"
    sha256 "3c1da678be4f7ee71c245fafa56c1b6f4d3e49e7c6d5cc9b5aafc30abf3e3bc3"
  end

  resource "cl-mssql" do
    url "https://beta.quicklisp.org/archive/cl-mssql/2013-10-03/cl-mssql-20131003-git.tgz"
    sha256 "d34ada2cdabd305fd1d76a02ed60eaf4de02cd2e895060208b41d801c94373fa"
  end

  resource "cl-ppcre" do
    url "https://beta.quicklisp.org/archive/cl-ppcre/2015-09-23/cl-ppcre-2.0.11.tgz"
    sha256 "626d4e1f78659d0b6e4d675c94e39afb1f602427724c961b1e4f029b348f4cb6"
  end

  resource "cl-sqlite" do
    url "https://beta.quicklisp.org/archive/cl-sqlite/2013-06-15/cl-sqlite-20130615-git.tgz"
    sha256 "105333bbdccc3c2ab76ce4a35c63e6b27ac8a7a0967971c4addd666df7766135"
  end

  resource "cl-unicode" do
    url "https://beta.quicklisp.org/archive/cl-unicode/2014-12-17/cl-unicode-0.1.5.tgz"
    sha256 "d690480a82bfaa8d5dba29b68bc24f13e4e485f825904e5822879a280bc6a5c9"
  end

  resource "cl-utilities" do
    url "https://beta.quicklisp.org/archive/cl-utilities/2010-10-06/cl-utilities-1.2.4.tgz"
    sha256 "07a9318732d73b5195b1a442391d10395c7de471f1fe12feedfe71b1edbd51fc"
  end

  resource "closer-mop" do
    url "https://beta.quicklisp.org/archive/closer-mop/2015-10-31/closer-mop-20151031-git.tgz"
    sha256 "8c75b2470e7e1a5d0b1ed6bc572704b10bf7ee340f87d0c1ae0190456c6cfb94"
  end

  resource "command-line-arguments" do
    url "https://beta.quicklisp.org/archive/command-line-arguments/2015-07-09/command-line-arguments-20150709-git.tgz"
    sha256 "b032a2a750fe335be6b7327e8f87d39ed1669c671f010544b838522606a9c17c"
  end

  resource "drakma" do
    url "https://beta.quicklisp.org/archive/drakma/2015-10-31/drakma-2.0.2.tgz"
    sha256 "5f40ae3c8c8cabb834234a17c8f89dd8cc35cc104b89a8f86636b4ee5280fcae"
  end

  resource "dynamic-classes" do
    url "https://beta.quicklisp.org/archive/dynamic-classes/2013-01-28/dynamic-classes-20130128-git.tgz"
    sha256 "4a93d3a39dca61c87b29877fa9707b647fc08f117f80f2a741f649e4d04c4b44"
  end

  resource "esrap" do
    url "https://beta.quicklisp.org/archive/esrap/2015-10-31/esrap-20151031-git.tgz"
    sha256 "ad18ba00760f48e291c0a3b1e884ff4a6414d4994902b67bf3ce50ca8b0a16ba"
  end

  resource "flexi-streams" do
    url "https://beta.quicklisp.org/archive/flexi-streams/2015-07-09/flexi-streams-1.0.15.tgz"
    sha256 "f70c76e1724978100e26d9e0e0a0844939cde084b0d7f5623f1adbc8cb187d7e"
  end

  resource "garbage-pools" do
    url "https://beta.quicklisp.org/archive/garbage-pools/2013-07-20/garbage-pools-20130720-git.tgz"
    sha256 "05f014fd95526107af6d99a612b78292fbf3b8a6e9e2efcb04d6ab7e835ab6c5"
  end

  resource "ieee-floats" do
    url "https://beta.quicklisp.org/archive/ieee-floats/2015-06-08/ieee-floats-20150608-git.tgz"
    sha256 "ad1c0a62b9434f8aa0d10a2b6a725d68830008a1e5fba3b41d9890b84281ebb0"
  end

  resource "ironclad" do
    url "https://beta.quicklisp.org/archive/ironclad/2014-11-06/ironclad_0.33.0.tgz"
    sha256 "e7f33e7ad79106de7a7f861013cde2812b83a22f6ab340fb37a6c4fad0efa0d1"
  end

  resource "iterate" do
    url "https://beta.quicklisp.org/archive/iterate/2014-07-13/iterate-20140713-darcs.tgz"
    sha256 "c50264e19b0c5cf52f05dc45889a48c96d449ce24dd15018a228fa6a722405b2"
  end

  resource "local-time" do
    url "https://beta.quicklisp.org/archive/local-time/2015-06-08/local-time-20150608-git.tgz"
    sha256 "5c251852c09e508962a02ab441fccc07524bcb6059c6bc77ec4f1d20472bee3c"
  end

  resource "lparallel" do
    url "https://beta.quicklisp.org/archive/lparallel/2015-09-23/lparallel-20150923-git.tgz"
    sha256 "deaf06f4796630c85fcc1fff3b9b715d674cc3ecb9ab742b0cca77132e4440ec"
  end

  resource "md5" do
    url "https://beta.quicklisp.org/archive/md5/2015-08-04/md5-20150804-git.tgz"
    sha256 "856d522b4f60af0ead0435114c11100c0f5348e5e1db5fffe93a851be54dc7e9"
  end

  resource "metabang-bind" do
    url "https://beta.quicklisp.org/archive/metabang-bind/2014-11-06/metabang-bind-20141106-git.tgz"
    sha256 "84b0d7384a8f385140a11820e4f57cfd630c8e7ff48b44d357e9af9acd82be86"
  end

  resource "metatilities-base" do
    url "https://beta.quicklisp.org/archive/metatilities-base/2012-09-09/metatilities-base-20120909-git.tgz"
    sha256 "2a0f3f2b3d9724035e03c4bcb9fa587a2a638bd0fd64f20926d83efa09e8d4f8"
  end

  resource "nibbles" do
    url "https://beta.quicklisp.org/archive/nibbles/2015-07-09/nibbles-20150709-git.tgz"
    sha256 "2fc1e3a8a62f322904b2bb0f3743c25c0e75939944ed8de4eb73f50670d9f652"
  end

  resource "parse-number" do
    url "https://beta.quicklisp.org/archive/parse-number/2014-08-26/parse-number-1.4.tgz"
    sha256 "90ae04cd1a43fe186d07e5f805faa6cc8a00d1134dd9d99b56e31fa2f5811279"
  end

  resource "postmodern" do
    url "https://beta.quicklisp.org/archive/postmodern/2015-10-31/postmodern-20151031-git.tgz"
    sha256 "636d7192e57f236dd580ceede1431ef0cdfbf9bc1906914fc98a691f2a88f65b"
  end

  resource "puri" do
    url "https://beta.quicklisp.org/archive/puri/2015-09-23/puri-20150923-git.tgz"
    sha256 "0a0784c4d592733c1232fdee1074e9898a091359da142985a44b9528bff02a25"
  end

  resource "py-configparser" do
    url "https://beta.quicklisp.org/archive/py-configparser/2013-10-03/py-configparser-20131003-svn.tgz"
    sha256 "9d5365e66f5d788535d53ebf4c733e7d0d47c5b5e5f817c151503325e8c69a81"
  end

  resource "qmynd" do
    url "https://beta.quicklisp.org/archive/qmynd/2015-08-04/qmynd-20150804-git.tgz"
    sha256 "a25ef1ed7bb162b40f964fd0e0baec1c6c6dca19b27aa09c05f6ed7f3061ca47"
  end

  resource "quri" do
    url "https://beta.quicklisp.org/archive/quri/2015-10-31/quri-20151031-git.tgz"
    sha256 "b7eba0392f588e9af57c47805bd9210ed1c35d0cde62e0fd5da80b2a658203be"
  end

  resource "salza2" do
    url "https://beta.quicklisp.org/archive/salza2/2013-07-20/salza2-2.0.9.tgz"
    sha256 "6aa36dc25fe2dfb411c03ad62edb39fcbf1d4ca8b45ba17a6ad20ebc9f9e10d4"
  end

  resource "split-sequence" do
    url "https://beta.quicklisp.org/archive/split-sequence/2015-08-04/split-sequence-1.2.tgz"
    sha256 "145c5c36e0b4edf77e2cf6df7f8c6b3aa9018211e269cafb97e9631bb7f3a58b"
  end

  resource "trivial-backtrace" do
    url "https://beta.quicklisp.org/archive/trivial-backtrace/2015-04-07/trivial-backtrace-20150407-git.tgz"
    sha256 "97d045b7701e3dcc49149a0a94e3648131bd586e803126d07a79f405f6c07cd1"
  end

  resource "trivial-features" do
    url "https://beta.quicklisp.org/archive/trivial-features/2015-09-23/trivial-features-20150923-git.tgz"
    sha256 "f7afa96fab42e57ccf86ccd787ee743913c7e2bcb549502ab85eb6948e636808"
  end

  resource "trivial-garbage" do
    url "https://beta.quicklisp.org/archive/trivial-garbage/2015-01-13/trivial-garbage-20150113-git.tgz"
    sha256 "08c0a03595843576835086dc5973cfb535f75f77de4b90e9c9b97c7eba97c1fb"
  end

  resource "trivial-gray-streams" do
    url "https://beta.quicklisp.org/archive/trivial-gray-streams/2014-08-26/trivial-gray-streams-20140826-git.tgz"
    sha256 "22757737e6b63a21f5e7f44980df8047f8c8294c290eeaaaf01bef1f31b80bda"
  end

  resource "trivial-utf-8" do
    url "https://beta.quicklisp.org/archive/trivial-utf-8/2011-10-01/trivial-utf-8-20111001-darcs.tgz"
    sha256 "8b17c345da11796663cfd04584445c62f09e789981a83ebefe7970a30b0aafd2"
  end

  resource "uiop" do
    url "https://beta.quicklisp.org/archive/uiop/2015-10-31/uiop-3.1.6.tgz"
    sha256 "8b01848d84a5c5dd6107aa63b4bcabb9b0d0889dd4eb351cfe88255f4ded9115"
  end

  resource "usocket" do
    url "https://beta.quicklisp.org/archive/usocket/2015-06-08/usocket-0.6.3.2.tgz"
    sha256 "2815c7bdf1352f1ac634204ec12457ff57dfe64170512e6416bb17eb4799fce6"
  end

  resource "uuid" do
    url "https://beta.quicklisp.org/archive/uuid/2013-08-13/uuid-20130813-git.tgz"
    sha256 "0e8657bdf7ad131641f6d878f953ebf74d3cda06b8be99dd8bb8cffbe34308de"
  end

  def install
    resources.each do |resource|
      resource.stage buildpath/"lib"/resource.name
    end

    ENV["CL_SOURCE_REGISTRY"] = "#{buildpath}/lib//:#{buildpath}//"
    ENV["ASDF_OUTPUT_TRANSLATIONS"] = "/:/"
    system "make", "pgloader-standalone", "BUILDAPP=buildapp"

    bin.install "build/bin/pgloader"
    man1.install "pgloader.1"
  end

  def launch_postgres(socket_dir)
    require "timeout"

    socket_dir = Pathname.new(socket_dir)
    mkdir_p socket_dir

    postgres_command = [
      "postgres",
      "--listen_addresses=",
      "--unix_socket_directories=#{socket_dir}"
    ]

    IO.popen(postgres_command * " ") do |postgres|
      begin
        ohai postgres_command * " "
        # Postgres won't create the socket until it's ready for connections, but
        # if it fails to start, we'll be waiting for the socket forever. So we
        # time out quickly; this is simpler than mucking with child process
        # signals.
        Timeout.timeout(5) { sleep 0.2 while socket_dir.children.empty? }
        yield
      ensure
        Process.kill(:TERM, postgres.pid)
      end
    end
  end

  test do
    # Remove any Postgres environment variables that might prevent us from
    # isolating this disposable copy of Postgres.
    ENV.reject! { |key, _| key.start_with?("PG") }

    ENV["PGDATA"] = testpath/"data"
    ENV["PGHOST"] = testpath/"socket"
    ENV["PGDATABASE"] = "brew"

    (testpath/"test.load").write <<-EOS.undent
      LOAD CSV
        FROM inline (code, country)
        INTO postgresql:///#{ENV["PGDATABASE"]}?tablename=csv
        WITH fields terminated by ','

      BEFORE LOAD DO
        $$ CREATE TABLE csv (code char(2), country text); $$;

      GB,United Kingdom
      US,United States
      CA,Canada
      US,United States
      GB,United Kingdom
      CA,Canada
    EOS

    system "initdb"

    launch_postgres(ENV["PGHOST"]) do
      system "createdb"
      system "pgloader", testpath/"test.load"
      assert_equal "6", shell_output("psql -Atc 'SELECT COUNT(*) FROM csv'").strip
    end
  end
end
