module Ftpmock
  module PathHelper
    module_function

    def clean(path)
      path = path.to_s
      path = path[1..-1] if path[0] == '/'
      path = Pathname(path).cleanpath
      return Pathname('') if path.to_s == '.'

      path
    end

    def join(path_a, path_b)
      clean Pathname(path_a.to_s).join(path_b.to_s)
    end
  end
end
