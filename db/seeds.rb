
# Initializates root admin account
admin = Admin.create(firstname: 'root', secondname: 'root', lastname: 'root', is_super: true)
admin.account = Account.create(login: 'root', password: 'root')