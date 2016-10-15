require "formula"

class Liquidfun < Formula
  homepage "http://google.github.io/liquidfun/"
  url "https://github.com/google/liquidfun/releases/download/v1.1.0/liquidfun-1.1.0.zip"
  sha1 "ad1bca48f617805394ca61ec890f84d2133bcba3"

  depends_on "cmake" => :build

  conflicts_with "box2d", :because => "liquidfun is based on box2d and include it"

  patch :DATA

  def install
    cd "liquidfun/Box2D"
    system "cmake", "-DBOX2D_INSTALL=ON",
                    "-DBOX2D_BUILD_SHARED=ON",
                    "-DBOX2D_BUILD_EXAMPLES=OFF",
                    *std_cmake_args
    system "make", "install"
    (include/"Box2D/Common").install "Box2D/Common/b2GrowableBuffer.h"
  end

  test do
    (testpath/"CMakeLists.txt").write <<-EOS.undent
      find_package(Box2D)
      include_directories(SYSTEM ${BOX2D_INCLUDE_DIRS})
      link_directories(${BOX2D_LIBRARY_DIRS})

      add_executable(helloworld test.cpp)
      target_link_libraries(helloworld ${BOX2D_LIBRARIES})
    EOS

    (testpath/'test.cpp').write <<-EOS.undent
      #include <Box2D/Box2D.h>
      int main() {
        b2Vec2 gravity(0.0f, -10.0f);
        b2World world(gravity);
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0.0f, -10.0f);
        b2Body* groundBody = world.CreateBody(&groundBodyDef);
        b2PolygonShape groundBox;
        groundBox.SetAsBox(50.0f, 10.0f);
        groundBody->CreateFixture(&groundBox, 0.0f);
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position.Set(0.0f, 4.0f);
        b2Body* body = world.CreateBody(&bodyDef);
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(1.0f, 1.0f);
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.3f;
        body->CreateFixture(&fixtureDef);
        float32 timeStep = 1.0f / 60.0f;
        int32 velocityIterations = 6;
        int32 positionIterations = 2;
        for (int32 i = 0; i < 60; ++i)
        {
          world.Step(timeStep, velocityIterations, positionIterations);
          b2Vec2 position = body->GetPosition();
          float32 angle = body->GetAngle();
        }
        return 0;
      }
    EOS

    system "cmake", "."
    system "make"
    system "./helloworld"
  end

end
__END__
diff --git a/liquidfun/Box2D/Box2D/CMakeLists.txt b/liquidfun/Box2D/Box2D/CMakeLists.txt
index f7656ce..72d80a8 100644
--- a/liquidfun/Box2D/Box2D/CMakeLists.txt
+++ b/liquidfun/Box2D/Box2D/CMakeLists.txt
@@ -247,7 +247,7 @@ if(BOX2D_INSTALL)
         set (BOX2D_INCLUDE_DIR "${CMAKE_INSTALL_PREFIX}/include")
         set (BOX2D_INCLUDE_DIRS "${BOX2D_INCLUDE_DIR}" )
         set (BOX2D_LIBRARY_DIRS "${CMAKE_INSTALL_PREFIX}/${LIB_INSTALL_DIR}")
-        set (BOX2D_LIBRARY Box2D)
+        set (BOX2D_LIBRARY liquidfun)
         set (BOX2D_LIBRARIES "${BOX2D_LIBRARY}")
         set (BOX2D_USE_FILE "${CMAKE_INSTALL_PREFIX}/${LIB_INSTALL_DIR}/cmake/Box2D/UseBox2D.cmake")
         configure_file(Box2DConfig.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/Box2DConfig.cmake" @ONLY ESCAPE_QUOTES)
-- 
