# -*- coding: utf-8 -*-
module Stone
  class Natives
    def environment(env)
      append_natives(env)
      return env
    end
    
    def append_natives(env)
      # ここで追加したメソッドはプログラム中で使える
      append(env, "www")
      append(env, "print")
      append(env, "puts")
    end
    
    def append(env, method_name)
      begin
        # ちなみにNativesクラスにないとKarnelから探してくるっぽい
        method = self.method(method_name)
      rescue
        raise "cannot find a native function: #{method_name}"
      end
      env.put(method_name, NativeFunction.new(method_name, method))
    end
    
    # NativeFunctionsを定義する
    def www(num)
      # 引数は配列で渡されてくる（function.rb）
      num[1].to_i.times do
        Object.method("print").call("www")
      end
      puts ""
      return nil
    end

    def print(str)
      Object.method("print").call(str[1].to_s)
      return nil
    end

    def puts(str)
      Object.method("puts").call(str[1].to_s)
      return nil
    end
  end
end
