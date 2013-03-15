module Tools

	def t_hex(value)
		return value.unpack('U'*value.length).collect {|x| x.to_s 16}.join
	end

end