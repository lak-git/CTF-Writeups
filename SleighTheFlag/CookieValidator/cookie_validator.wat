(module
  (type (;0;) (func (param i32 i32 i32) (result i32)))
  (type (;1;) (func (result i32)))
  (import "env" "memory" (memory (;0;) 1))
  (func (;0;) (type 0) (param i32 i32 i32) (result i32)
    (local i32)
    local.get 0
    i32.const 3
    i32.mul
    local.get 1
    i32.const 2
    i32.mul
    i32.add
    local.get 2
    i32.const 5
    i32.mul
    i32.add
    local.set 3
    local.get 3
    i32.const 1225
    i32.eq
    if (result i32)  ;; label = @1
      i32.const 1
    else
      i32.const 0
    end)
  (func (;1;) (type 1) (result i32)
    i32.const 36)
  (export "validate_cookie" (func 0))
  (export "get_flag_length" (func 1))
  (data (;0;) (i32.const 0) "SANTA{n0t_th3_r34l_fl4g}")
  (data (;1;) (i32.const 50) "SLEIGH{")
  (data (;2;) (i32.const 100) "w4sm_c")
  (data (;3;) (i32.const 150) "COOKIE{fake_flag_here}")
  (data (;4;) (i32.const 200) "00k13s")
  (data (;5;) (i32.const 250) "_4r3_d")
  (data (;6;) (i32.const 300) "XMAS{try_h4rd3r}")
  (data (;7;) (i32.const 350) "3l1c10")
  (data (;8;) (i32.const 400) "us}")
  (data (;9;) (i32.const 450) "FLAG{n1c3_try}")
  (data (;10;) (i32.const 500) "Recipe: sugar*3 + flour*2 + butter*5"))
