return {
	settings = {
		gopls = {
			analyses = {
				fieldalignment = true,
				shadow = true,
			},
			annotations = {
				bounds = true,
				escape = true,
				inline = true,
				['nil'] = true,
			},
			codelenses = {
				gc_details = true,
			},
			gofumpt = true,
			staticcheck = true,
		}
	}
}
