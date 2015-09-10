class Freeswitch < Formula
  desc "Telephony platform to route various communication protocols"
  homepage "https://freeswitch.org"
  url "https://freeswitch.org/stash/scm/fs/freeswitch.git",
      :tag => "v1.4.21",
      :revision => "87a059bafcc094bdb4899b6a20bcd215e249109e"

  head "https://freeswitch.org/stash/scm/fs/freeswitch.git"

  bottle do
    sha256 "c9fa9c639c622f8d19aec5f797d51586a3b04d85086cc7de023f9b1a8dbd452e" => :yosemite
    sha256 "c87a3fe0bc3bf979a3fdf061905d5253b454ea2e3626c7cbf4f236acc275c260" => :mavericks
    sha256 "ad4e2bd326f69554321a3a4037c11d81c80fe0d09238dfbb2df79d9e711ed599" => :mountain_lion
  end

  option "without-moh", "Do not install music-on-hold"
  option "without-sounds-en", "Do not install English (Callie) sounds"
  option "with-sounds-fr", "Install French (June) sounds"
  option "with-sounds-ru", "Install Russian (Elena) sounds"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :apr => :build

  depends_on "curl"
  depends_on "jpeg"
  depends_on "ldns"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "speex"
  depends_on "sqlite"

  #----------------------- Begin sound file resources -------------------------
  sounds_url_base = "https://files.freeswitch.org/releases/sounds"

  #---------------
  # music on hold
  #---------------
  moh_version = "1.0.50" # from build/moh_version.txt
  resource "sounds-music-8000" do
    url "#{sounds_url_base}/freeswitch-sounds-music-8000-#{moh_version}.tar.gz"
    version moh_version
    sha256 "557807409688e4a00be2597bd1a0e88907c48d8229a81d5a317b08a38bc905a4"
  end
  resource "sounds-music-16000" do
    url "#{sounds_url_base}/freeswitch-sounds-music-16000-#{moh_version}.tar.gz"
    version moh_version
    sha256 "d0578d19c0eef5a85de715cde4d2b86f9ff3c8e3a06715ae1612fb6291967772"
  end
  resource "sounds-music-32000" do
    url "#{sounds_url_base}/freeswitch-sounds-music-32000-#{moh_version}.tar.gz"
    version moh_version
    sha256 "ab9c502d0242f85bf2ea951af6c5a39996df0de851007ef73e1bab3412e343fd"
  end
  resource "sounds-music-48000" do
    url "#{sounds_url_base}/freeswitch-sounds-music-48000-#{moh_version}.tar.gz"
    version moh_version
    sha256 "d72e416ded81e0e8749145c82fee5c475841c143ee7b85f570f4cfb95c93c7e6"
  end

  #-----------
  # sounds-en
  #-----------
  sounds_en_version = "1.0.50" # from build/sounds_version.txt
  resource "sounds-en-us-callie-8000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-8000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "c1901d6df1bf0aa550e6ce035d7573c010168f625f4605813b153a0e9e0e48e2"
  end
  resource "sounds-en-us-callie-16000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-16000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "fb99c5df21fd73c99aa9d8fb8219a098952f8c22e5c0757f70972e2767a09342"
  end
  resource "sounds-en-us-callie-32000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-32000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "74cc7ef7b64d1b51fdb669d2b8db89afdd3cd678b94679b2d6636443c8c63ed8"
  end
  resource "sounds-en-us-callie-48000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-48000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "4bfa974cacb56cd99540831716bf7974dc1c99569a202b57120dc79e74877f1b"
  end

  #-----------
  # sounds-fr
  #-----------
  sounds_fr_version = "1.0.18" # from build/sounds_version.txt
  resource "sounds-fr-ca-june-8000" do
    url "#{sounds_url_base}/freeswitch-sounds-fr-ca-june-8000-#{sounds_fr_version}.tar.gz"
    version sounds_fr_version
    sha256 "f7fd5c84ff9b1c1929167a4b33f38d6770a44c5bcad4e5f96b86e3165bfd05d4"
  end
  resource "sounds-fr-ca-june-16000" do
    url "#{sounds_url_base}/freeswitch-sounds-fr-ca-june-16000-#{sounds_fr_version}.tar.gz"
    version sounds_fr_version
    sha256 "5c4e45be5988e7763b196a453722f3a5dd41f79b280a37a8960cf65d390318a7"
  end
  resource "sounds-fr-ca-june-32000" do
    url "#{sounds_url_base}/freeswitch-sounds-fr-ca-june-32000-#{sounds_fr_version}.tar.gz"
    version sounds_fr_version
    sha256 "b0c30f112bfd40e0422a93b30d251072e9847274a39d3407a06f3528d8935bfe"
  end
  resource "sounds-fr-ca-june-48000" do
    url "#{sounds_url_base}/freeswitch-sounds-fr-ca-june-48000-#{sounds_fr_version}.tar.gz"
    version sounds_fr_version
    sha256 "4c7f6d373b72b5af5bad028b3b193d1b862abcee4466bb6f398f1d3f20befd0b"
  end

  #-----------
  # sounds-ru
  #-----------
  sounds_ru_version = "1.0.50" # from build/sounds_version.txt
  resource "sounds-ru-RU-elena-8000" do
    url "#{sounds_url_base}/freeswitch-sounds-ru-RU-elena-8000-#{sounds_ru_version}.tar.gz"
    version sounds_ru_version
    sha256 "d3a67f8983470056b48212935177e9996891081ca01ba5fb468dd9ccd593f981"
  end
  resource "sounds-ru-RU-elena-16000" do
    url "#{sounds_url_base}/freeswitch-sounds-ru-RU-elena-16000-#{sounds_ru_version}.tar.gz"
    version sounds_ru_version
    sha256 "5cf4ac2ad85bb4903272bf462581cb73867038408bce4aa3073d2200ef5d734d"
  end
  resource "sounds-ru-RU-elena-32000" do
    url "#{sounds_url_base}/freeswitch-sounds-ru-RU-elena-32000-#{sounds_ru_version}.tar.gz"
    version sounds_ru_version
    sha256 "6b68ad561c617ede92c830eb7d27f8dd47b0ebe566874d468c16958d3148ba98"
  end
  resource "sounds-ru-RU-elena-48000" do
    url "#{sounds_url_base}/freeswitch-sounds-ru-RU-elena-48000-#{sounds_ru_version}.tar.gz"
    version sounds_ru_version
    sha256 "fc67a97ef4db62b4559ecd30ee7da710a7f848f585cf7190c9d0ca39946c2999"
  end

  #------------------------ End sound file resources --------------------------

  def install
    system "./bootstrap.sh", "-j"

    # tiff will fail to find OpenGL unless told not to use X
    inreplace "libs/tiff-4.0.2/configure.gnu", "--with-pic", "--with-pic --without-x"

    system "./configure", "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--exec_prefix=#{prefix}"

    system "make"
    system "make", "install", "all"

    if build.with?("moh")
      # Should be equivalent to: system "make", "cd-moh-install"
      mkdir_p prefix/"sounds/music"
      [8, 16, 32, 48].each do |n|
        resource("sounds-music-#{n}000").stage do
          cp_r ".", prefix/"sounds/music"
        end
      end
    end

    if build.with?("sounds-en")
      # Should be equivalent to: system "make", "cd-sounds-install"
      mkdir_p prefix/"sounds/en"
      [8, 16, 32, 48].each do |n|
        resource("sounds-en-us-callie-#{n}000").stage do
          cp_r ".", prefix/"sounds/en"
        end
      end
    end

    if build.with?("sounds-fr")
      # Should be equivalent to: system "make", "cd-sounds-fr-install"
      mkdir_p prefix/"sounds/fr"
      [8, 16, 32, 48].each do |n|
        resource("sounds-fr-ca-june-#{n}000").stage do
          cp_r ".", prefix/"sounds/fr"
        end
      end
    end

    if build.with?("sounds-ru")
      # Should be equivalent to: system "make", "cd-sounds-ru-install"
      mkdir_p prefix/"sounds/ru"
      [8, 16, 32, 48].each do |n|
        resource("sounds-ru-RU-elena-#{n}000").stage do
          cp_r ".", prefix/"sounds/ru"
        end
      end
    end
  end

  plist_options :manual => "freeswitch -nc --nonat"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
        <true/>
      <key>Label</key>
        <string>#{plist_name}</string>
      <key>ProgramArguments</key>
        <array>
          <string>#{bin}/freeswitch</string>
          <string>-nc</string>
          <string>-nonat</string>
        </array>
      <key>RunAtLoad</key>
        <true/>
      <key>ServiceIPC</key>
        <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/freeswitch", "-version"
  end
end
