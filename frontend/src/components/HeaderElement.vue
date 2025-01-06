<template>
    <div class="page-wrapper">
        <header class="title">
            <h1>Blog Post</h1>
            <div v-if="userToken"  class="right">
                <router-link :to="`/user-profile/${user.id}`" class="nav-button auth-button">Profile</router-link>
            </div>
        </header>
        <header class="header">
            <div class="left">
                <router-link to="" class="nav-button home-button">Home</router-link>
            </div>
            <div class="right">
                <div v-if="!userToken" class="auth-container">
                    <router-link to="/sign-in" class="nav-button auth-button">Sign In</router-link>
                    <router-link to="/sign-up" class="nav-button auth-button">Sign Up</router-link>
                </div>
                <div v-if="userToken" class="auth-container">
                    <router-link to="/new-blogpost" class="nav-button auth-button">New Blog-Post</router-link>
                    <button @click="signOut" class="nav-button auth-button profile-button">Sign Out</button>
                </div>
            </div>
        </header>
    </div>
</template><script>
import { mapActions, mapGetters } from 'vuex';
import axios from 'axios';

export default {
    computed: {
        ...mapGetters('auth', ['getUser']),
        userToken() {
            return this.getUser.user_token;
        },
        user() {
            return this.getUser.current_user;
        }
    },
    methods: {
        ...mapActions('auth', ['logout']),
        async signOut() {
            try {
                const response = await axios.delete(
                    `http://127.0.0.1:3000/api/v1/sessions/${this.user.id}`,
                    {
                        headers: {
                            'Authorization': `Bearer ${this.userToken}`
                        }
                    }
                );
                this.logout();
                console.log('Signed out:', response.data);
                this.$router.push('/sign-in');
            } catch (error) {
                console.error('Error during sign out:', error);
            }
        }
    }
};
</script>

<style scoped>
.page-wrapper {
    background: linear-gradient(135deg, #f6f9fc 0%, #eef2f7 100%);
}

.title {
    background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
    font-family: 'Arial', sans-serif;
    font-size: 2.0em;
    color: white;
    text-align: center;
    margin: 0;
    padding: 20px 0;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
    letter-spacing: 2px;
    position: relative;
    display: flex;
    justify-content: center; 
    align-items: center;
}

.title h1 {
    margin: 0;  
}

.header {
    display: flex;
    justify-content: space-between; 
    align-items: center;
    padding: 15px 30px;
    background: white;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    position: relative;
}

.left {
    display: flex;
    align-items: center;
}

.right {
    display: flex;
    align-items: center;
    position: absolute; 
    right: 30px;  
}

.auth-container {
    display: flex;
    gap: 12px;
}

.nav-button {
    text-decoration: none;
    padding: 10px 20px;
    border-radius: 8px;
    font-size: 1.1em;
    font-weight: 500;
    transition: all 0.3s ease;
    border: none;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}

.home-button {
    background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
    color: white;
}

.auth-button {
    background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
    color: white;
}

.home-button:hover, .auth-button:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.home-button:hover {
    background: linear-gradient(135deg, #2980b9 0%, #2c3e50 100%);
}

.auth-button:hover {
    background: linear-gradient(135deg, #27ae60 0%, #219a52 100%);
}

.router-link-active {
    background: linear-gradient(135deg, #34495e 0%, #2c3e50 100%);
    color: white;
}

</style>
