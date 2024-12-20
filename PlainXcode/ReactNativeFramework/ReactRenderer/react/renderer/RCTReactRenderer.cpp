//
//  RCTReactRenderer.cpp
//  ReactRenderer
//
//  Created by Riccardo Cipolleschi on 03/12/2024.
//

#include "RCTReactRenderer.h"


int Renderer::render(const std::string &tree) {
  if (tree == "root") {
    return 1;
  }
  
  if (tree == "view") {
    return 2;
  }
  
  if (tree == "text") {
    return 3;
  }
  
  if (tree == "image") {
    return 4;
  }
  
  return -1;
}

