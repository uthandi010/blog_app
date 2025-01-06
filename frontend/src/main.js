import { createApp } from 'vue';
import { createStore } from 'vuex';
import App from './App.vue';
import router from './routes/route.js';
import auth from './store/modules/auth.js'; 
const store = createStore({
  modules: {
    auth,
  },
});

const app = createApp(App);
app.use(store);
app.use(router);
app.mount('#app');
