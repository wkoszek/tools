#!/usr/bin/env ruby

class SrcRepo
	def initialize(root_repo_path, repo_name)
		@root_repo_path = root_repo_path
		@repo_name = repo_name
		@repo_path = "#{root_repo_path}/#{repo_name}"
		@score = 0
		@score_max = 2
	end

	def test_one
		d = Dir.new(@repo_path)
		fns_all = d.map{|fn| fn}
		d.close()

		readme_have = false
		ci_have = false
		fns_all.each do |fn|
			#print "FN---#{fn}\n"
			if fn == "README.md" then
				readme_have = true
			end
			if fn == ".travis.yml" or fn == "circle.yml" \
					or fn == "appveyor.yml"
				ci_have = true
			end
		end

		if !readme_have then print "README wasn't found in #{@repo_path}\n" else @score += 1 end
		if !ci_have then print "CI system config wasn't found in #{@repo_path}\n" else @score += 1 end

		if false and readme_have then
			maybe_add_analytics("#{@repo_path}/README.md", @repo_name)
		end
		check_github()
	end

	def check_github()
		ret = `(cd #{@repo_path} && git status)`
		ok = false
		ret.split("\n").each do |s|
			if s =~ /nothing to commit, working directory clean/ then
				ok = true
			end
		end
		if not ok then
			print "----------------------------------------- #{@repo_path} ----------------\n" 
			print ret
			print "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
		end
	end

	def maybe_add_analytics(path, repo_name)
		f = File.open(path, "a")
		user = 'wkoszek'
		id = "UA-67150227-1"
		s = "[![Analytics](https://ga-beacon.appspot.com/%s/%s/%s)](https://github.com/%s/%s)\n" % [id, user, repo_name, user, repo_name]
		print s
		#f.write(s)
		f.close()
	end

	def score
		@score
	end
	def score_max
		@score_max
	end

	def self.repo_test_all(root_repos_path)
		repos = []
		d = Dir.new(root_repos_path)
		d.map{|i| i}.select{|fn| fn if not fn =~ /\.$/ }.each do |repo_name|
			repo_path = "#{root_repos_path}/#{repo_name}"
			next if not File.directory?(repo_path)
			r = SrcRepo.new(root_repos_path, repo_name)
			r.test_one()
			if not r then return False else repos.push(r) end
		end
		d.close()
		return repos
	end

	def to_s
		"-- #{@root_repo_path} #{@repo_name} score=#{@score} score_max=#{@score_max}\n"
	end
end

def main(repos_path)
	repos = SrcRepo.repo_test_all(repos_path)

	pts_score_actual = repos.map{|r| r.score()}.reduce(:+)
	pts_score_possible = repos.map{|r| r.score_max()}.reduce(:+)
	pts_percent = (pts_score_actual.to_f / pts_score_possible.to_f) * 100.00

	print "--\n"
	print "Possible score    : #{pts_score_possible}\n"
	print "Your current score: #{pts_score_actual}\n"
	print "                  : %2.2f%%\n" % pts_percent
end

main("/w/repos")
