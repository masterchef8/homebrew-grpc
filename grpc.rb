class Grpc < Formula
 desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/masterchef8/homebrew-grpc/releases/download/v1.0/grpc-bottle.tar"
  sha256 "4802c31e7341ec14f7053b5efdfdbfcef7f8306c34e46f0c3bdb6ae45ef45140"
   head "https://github.com/masterchef8/homebrew-grpc.git"

   bottle do
     sha256 "4802c31e7341ec14f7053b5efdfdbfcef7f8306c34e46f0c3bdb6ae45ef45140" => :catalina
     sha256 "6cc94b6a248af3cd10daa68b732142de4a1a5d4e5b2eaa73fb7bd537fe57cfc7" => :mojave
     sha256 "fc1760f5aa11cb91f4d535fb0c236197be7406bcab0caf7d5607a829a58a9c8a" => :high_sierra
   end
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl@1.1"
  depends_on "protobuf"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
  end

  def install
    system "make", "install", "prefix=#{prefix}"

    system "make", "install-plugins", "prefix=#{prefix}"

    (buildpath/"third_party/googletest").install resource("gtest")
    system "make", "grpc_cli", "prefix=#{prefix}"
    bin.install "bins/opt/grpc_cli"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <grpc/grpc.h>
      int main() {
        grpc_init();
        grpc_shutdown();
        return GRPC_STATUS_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lgrpc", "-o", "test"
    system "./test"
  end
end
