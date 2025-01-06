// auth.js

export default {
  namespaced: true,
  state: {
    current_user: JSON.parse(localStorage.getItem('current_user')) || {}, 
    user_token: localStorage.getItem('user_token') || "" 
  },
  mutations: {
    ADD_USER(state, user_data) {
      state.current_user = user_data.user;
      state.user_token = user_data.token;

      localStorage.setItem('current_user', JSON.stringify(user_data.user));
      localStorage.setItem('user_token', user_data.token);
    },
    LOGOUT(state) {
      state.current_user = {};
      state.user_token = "";
      
      localStorage.removeItem('current_user');
      localStorage.removeItem('user_token');
    }
  },
  actions: {
    addUser({ commit }, user_data) {
      commit('ADD_USER', user_data);
    },
    logout({ commit }) {
      commit('LOGOUT');
    }
  },
  getters: {
    getUser(state) {
      return {
        current_user: state.current_user,
        user_token: state.user_token
      };
    },
  },
};
