/*

  VectorMath.dart

  Copyright (C) 2013 John McCutchan <john@johnmccutchan.com>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/

part of vector_math_common;

class aabb3 {
  vec3 _min;
  vec3 _max;

  vec3 get min => _min;
  vec3 get max => _max;

  aabb3() {
    _min = new vec3.zero();
    _max = new vec3.zero();
  }

  aabb3.copy(aabb3 other) {
    _min = new vec3.copy(other._min);
    _max = new vec3.copy(other._max);
  }

  aabb3.minmax(vec3 min_, vec3 max_) {
    _min = new vec3.copy(min_);
    _max = new vec3.copy(max_);
  }

  void copyMinMax(vec3 min_, vec3 max_) {
    max_.copyFrom(_max);
    min_.copyFrom(_min);
  }

  void copyCenterAndHalfExtents(vec3 center, vec3 halfExtents) {
    center.copyFrom(_min);
    center.add(_max);
    center.scale(0.5);
    halfExtents.copyFrom(_max);
    halfExtents.sub(_min);
    halfExtents.scale(0.5);
  }

  void copyFrom(aabb3 o) {
    _min.copyFrom(o._min);
    _max.copyFrom(o._max);
  }

  void copyInto(aabb3 o) {
    o._min.copyFrom(_min);
    o._max.copyFrom(_max);
  }

  aabb3 transform(mat4 T) {
    vec3 center = new vec3.zero();
    vec3 halfExtents = new vec3.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    T.transform3(center);
    T.absoluteRotate(halfExtents);
    _min.copyFrom(center);
    _max.copyFrom(center);

    _min.sub(halfExtents);
    _max.add(halfExtents);
    return this;
  }

  aabb3 rotate(mat4 T) {
    vec3 center = new vec3.zero();
    vec3 halfExtents = new vec3.zero();
    copyCenterAndHalfExtents(center, halfExtents);
    T.absoluteRotate(halfExtents);
    _min.copyFrom(center);
    _max.copyFrom(center);

    _min.sub(halfExtents);
    _max.add(halfExtents);
    return this;
  }

  aabb3 transformed(mat4 T, aabb3 out) {
    out.copyFrom(this);
    return out.transform(T);
  }

  aabb3 rotated(mat4 T, aabb3 out) {
    out.copyFrom(this);
    return out.rotate(T);
  }

  void getPN(vec3 planeNormal, vec3 outP, vec3 outN) {
    outP.x = planeNormal.x < 0.0 ? _min.x : _max.x;
    outP.y = planeNormal.y < 0.0 ? _min.y : _max.y;
    outP.z = planeNormal.z < 0.0 ? _min.z : _max.z;

    outN.x = planeNormal.x < 0.0 ? _max.x : _min.x;
    outN.y = planeNormal.y < 0.0 ? _max.y : _min.y;
    outN.z = planeNormal.z < 0.0 ? _max.z : _min.z;
  }
}
