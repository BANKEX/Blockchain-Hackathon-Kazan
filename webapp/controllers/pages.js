exports.home = function (req, res) {
	res.render('pages/home', {
		title: 'Home',
		actions: [
			{ title: 'Регистрация кредитора', url: 'lender' },
			{ title: 'Регистрация заёмщика', url: 'borrower' }
		]
	})
}