#!/usr/bin/env ruby

require 'yaml'

# reads the private config with various libraries.
# initialized the GitLab library with security tokens
def gitlab_init
	cfg = YAML.load(File.read(File.join(ENV['HOME'], ".privcfg.yml")))
	cfg_gitlab = cfg['gitlab']
	Gitlab.endpoint = cfg_gitlab['endpoint']
	Gitlab.private_token = cfg_gitlab['private_token']
end
