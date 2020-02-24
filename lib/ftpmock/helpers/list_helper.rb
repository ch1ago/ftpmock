require 'psych'

module Ftpmock
  module ListHelper
    module_function

    def read(cache_path, chdir, key)
      key = PathHelper.join(chdir, key).to_s if chdir
      dataset = read_dataset(cache_path)
      dataset[key]
    end

    def write(cache_path, chdir, key, list)
      key = PathHelper.join(chdir, key).to_s if chdir
      dataset = read_dataset(cache_path)
      dataset[key] = list
      write_dataset(cache_path, dataset)
      true
    end

    def read_dataset(cache_path)
      path = path_for(cache_path)
      string = path.read
      load(string)
    end

    def write_dataset(cache_path, dataset)
      path = path_for(cache_path)
      content = dump(dataset)
      path.write(content)
    end

    def path_for(cache_path)
      cache_path = PathHelper.clean(cache_path)
      cache_path.exist? || FileUtils.mkdir_p(cache_path)
      path = PathHelper.clean("#{cache_path}/list.yml")
      path.exist? || path.write(dump(new_list))
      path
    end

    def new_list
      {}
    end

    def load(string)
      Psych.load(string)
    end

    def dump(data)
      Psych.dump(data)
    end
  end
end
