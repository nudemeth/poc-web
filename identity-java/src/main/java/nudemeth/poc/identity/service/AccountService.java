package nudemeth.poc.identity.service;

import nudemeth.poc.identity.model.UserModel;

public interface AccountService {
    UserModel getUserFromLogin(String login);
}