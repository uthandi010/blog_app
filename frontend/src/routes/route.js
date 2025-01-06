import { createRouter, createWebHistory } from 'vue-router';
import { useStore } from 'vuex'; 
import SignIn from '../components/users/SignIn.vue';
import SignUp from '../components/users/SignUp.vue';
import BodyElement from '../components/blogpost/BodyElement.vue';
import NewBlogPost from '../components/blogpost/NewBlogpost.vue';
import ShowBlogpost from '../components/blogpost/ShowBlogpost.vue';
import UserProfile from '../components/users/UserProfile.vue';


const routes = [
    {
        path: '/sign-in',
        name: 'SignIn',
        component: SignIn,
    },
    {
        path: '/sign-up',
        name: 'SignUp',
        component: SignUp,
    },
    {
        path: '/',
        name: 'BodyElement',
        component: BodyElement,
    },
    {
        path: '/new-blogpost',
        name: 'NewBlogPost',
        component: NewBlogPost, 
    },
    {
        path: '/new-blogpost/:id',
        name: 'NewBlogPostwithid',
        component: NewBlogPost, 
        props: true,
    },
    {
        path: '/blogpost/:id',
        name: 'ShowBlogpost',
        component: ShowBlogpost,
    },
    {
        path:'/user-profile/:id',
        name: 'UserProfile',
        component: UserProfile,
    },
    {
        path: '/:pathMatch(.*)*', 
        name: 'NotFound',
        component: BodyElement, 
    },

];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

router.beforeEach((to, _, next) => {
    const store = useStore(); 
    const userToken = store.state.auth.user_token; 

    if (userToken) {
        if (to.path === '/sign-in' || to.path === '/sign-up' ){
            return next({ path: '/' });
        }
    } 
    else {
        if (to.path !== '/sign-in' && to.path !== '/sign-up') {
            return next({ path: '/sign-in' });
        }
    }

    next(); 
});

export default router;
