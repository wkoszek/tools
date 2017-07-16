#!/usr/bin/env ruby
all = `t followings`.split(/\n/)
preserve = `cat l`.split(/\n/)
to_remove = all - preserve
`t unfollow #{to_remove.join(" ") }`

