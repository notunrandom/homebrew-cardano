class LibsodiumCardano < Formula
  desc "Cardano fork of libsodium crypto library"
  homepage "https://github.com/intersectmbo/libsodium"
  url "https://github.com/intersectmbo/libsodium/archive/dbb48cce5429cb6585c9034f002568964f1ce567.tar.gz"
  version "1.0.0"
  sha256 "e4f29ae3c16037e484bb69e3fa22a5565c42adf497f8f88e61ff8d9486ab863e"
  license "ISC"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/libsodium-cardano-1.0.0"
    sha256 cellar: :any,                 arm64_tahoe:  "bc43924ba437da41ba0deb6d12065abfab7fae64eeb6766543571cb522997b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "20256af89e4a220c223547e80531e536371edd61544d5ea6d1db10d94e2b6a20"
  end

  depends_on "autoconf" => :build
  depends_on "autogen" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  conflicts_with "libsodium"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      You may need to set environment variables for this library to work, e.g.:
        export CPATH="#{opt_include}:$CPATH"
        export LDFLAGS="-L#{opt_lib} -lsodium $LDFLAGS"
        export LD_LIBRARY_PATH="#{opt_lib}:$LD_LIBRARY_PATH"
      Alternatively you can use pkgconf, e.g.:
        clang $(pkgconf --cflags --libs libsodium) -o test test.c
      However, if you are not using pkgconf from Homebrew, this may require you
      to set another environment variable:
        export PKG_CONFIG_PATH=#{HOMEBREW_PREFIX}/lib/pkgconfig:$PKG_CONFIG_PATH
    EOS
  end

  test do
    (testpath/"test.c").write <<~CFILE
      #include <sodium.h>
      int main(void) {
          if (sodium_init() == -1) {
              return 1;
          }
          return 0;
      }
    CFILE
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsodium", "-o", "test"
    system "./test"
  end
end
