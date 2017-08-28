exports.home = function (req, res) {
	res.render('pages/home', {
		title: 'Home'
	})
}

exports.deploy = function (req, res) {
	res.render('pages/deploy', {
		title: 'Создание контракта',
		bank: '0x24ecbda81f238aca238e68d339c583c0cece865a',
		borrower: '0x24ecbda81f238aca238e68d339c583c0c234g343',
		depository:	'0x24ecbda81f238aca238e68d339c583c0c342265a',
		registry: '0x24ecbda81f238aca238e68d339c583c0cece865a',
	})
}