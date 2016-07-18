GITHUB_CONFIG = YAML::load(ERB.new(File.read(Rails.root.join "config","github_config.yml")).result)[Rails.env]
RIGHTSCALE_CONFIG = YAML::load(ERB.new(File.read(Rails.root.join "config","rightscale_config.yml")).result)[Rails.env]
