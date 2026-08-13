class LmdbAT0936 < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://github.com/LMDB/lmdb"
  url "https://github.com/LMDB/lmdb/archive/refs/tags/LMDB_0.9.36.tar.gz"
  sha256 "7d55c3cbc1ef55f9b0076d3ddb16d0d9996d05b9caa7ca889ce10430ac677b90"
  license "OLDAP-2.8"
  version_scheme 1

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/lmdb@0.9.36-0.9.36"
    sha256 cellar: :any, arm64_tahoe:  "bd4522cd4eb922cc2356fbd2e4084d286969ea0d15109e876e69954df2daac6f"
    sha256 cellar: :any, arm64_linux:  "4c56233a1079a3918219d5defe14a1d91be511e174a6fca62c52602ad45bedb7"
    sha256 cellar: :any, x86_64_linux: "517c26adf986c658b97daf0b897146638c0077c90d44c1dcca1e052312464049"
  end

  depends_on "pkgconf" => :test

  def install
    cd "libraries/liblmdb" do
      args = []
      args << "SOEXT=.dylib" if OS.mac?
      system "make", *args
      system "make", "install", *args, "prefix=#{prefix}"
    end

    (lib/"pkgconfig/lmdb.pc").write pc_file
    (lib/"pkgconfig").install_symlink "lmdb.pc" => "liblmdb.pc"
  end

  def pc_file
    <<~EOS
      prefix=#{opt_prefix}
      exec_prefix=${prefix}
      libdir=${prefix}/lib
      includedir=${prefix}/include

      Name: lmdb
      Description: #{desc}
      URL: #{homepage}
      Version: #{version}
      Libs: -L${libdir} -llmdb
      Cflags: -I${includedir}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")

    # Make sure our `lmdb.pc` can be read by `pkg-config`.
    system "pkg-config", "lmdb"
  end
end
