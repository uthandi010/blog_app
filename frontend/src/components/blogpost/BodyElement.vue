<template>
  <div class="page-wrapper">
    <div class="blog-container">
      <div class="blog-card" v-for="(post, index) in blogPosts" :key="index">
        <img :src="post.image_url" :alt="post.title" class="blog-image">
        <div class="blog-content">
          <div class="content-row">
            <span class="label">Title</span>
            <h3 class="blog-title">{{ post.title }}</h3>
          </div>
          <div class="content-row">
            <span class="label">Author</span>
            <p class="blog-author">{{post.user.firstname }} {{ post.user.lastname }}</p>
          </div>
          <div class="content-row">
            <span class="label">Description</span>
            <p class="blog-description">{{ post.description }}</p>
          </div>
          <div class="content-row">
            <router-link :to="`/blogpost/${post.id}`" class="nav-button auth-button">View</router-link>
            <button @click="handleLike(post.id,post.isLiked)" class="like-button"><p v-if="post.likes.length > 0">{{ post.likes.length }}</p>
              <img :src="require('@/assets/like.png')" :alt="post.title" class="like-icon">
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import { mapGetters } from 'vuex';

export default {
  name: 'BodyElement',
  data() {
    return {
      blogPosts: [],
      like_id: null
    };
  },
  computed: {
        ...mapGetters('auth', ['getUser']),
        userToken() {
            return this.getUser.user_token;
        },
        current_user() {
            return this.getUser.current_user;
        }
    },
  created() {
    this.fetchBlogPosts();
  },
  methods: {
    async fetchBlogPosts() {
      try {
        const response = await axios.get('http://127.0.0.1:3000/api/v1/blog_posts', {
          headers: {
            'Authorization': `Bearer ${this.userToken}`
          }
        });
        
        this.blogPosts = response.data.blog_posts;
      } catch (error) {
        console.error('Error fetching blog posts:', error);
      }
    },
    async handleLike(postId, isLiked) {
      if (isLiked){
        const post = this.blogPosts.find(post => post.id === postId);
        if (post) {
          const like = post.likes.find(like => like.user_id === this.current_user.id);
          if (like) {
            this.like_id = like.id;
          }
        }
      }
      try {
        const url = isLiked ? `http://127.0.0.1:3000/api/v1/blog_posts/${postId}/likes/${this.like_id}` : `http://127.0.0.1:3000/api/v1/blog_posts/${postId}/likes`;
        const method = isLiked ? 'delete' : 'post';

        const response = await axios({
          method,
          url,
          headers: {
            'Authorization': `Bearer ${this.userToken}`,
          },
        });
        console.log(response.data.message)
        this.fetchBlogPosts();
      } catch (error) { 
        console.error('Error toggling like:', error);
      }
    },
  }
};
</script>

<style scoped>
.page-wrapper {
  min-height: 100vh;
  background: linear-gradient(135deg, #f6f9fc 0%, #eef2f7 100%);
  padding: 20px;
}

.blog-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 25px;
  padding: 20px;
  max-width: 1400px;
  margin: 0 auto;
}

.blog-card {
  background: #ffffff;
  border-radius: 15px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  position: relative;
  display: flex;
  flex-direction: column;
}

.blog-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
}

.blog-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 5px;
  background: linear-gradient(to right, #2ecc71, #27ae60);
  transition: height 0.3s ease;
}

.blog-card:hover::before {
  height: 7px;
}

.blog-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.blog-content {
  padding: 20px;
  background: linear-gradient(135deg, #c2ecd9 0%, #a8e6c9 100%);
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.content-row {
  display: flex;
  align-items: flex-start;
  gap: 12px;
}

.label {
  min-width: 90px;
  font-weight: 600;
  color: #2c3e50;
  background-color: rgba(255, 255, 255, 0.7);
  padding: 6px 12px;
  border-radius: 6px;
  font-size: 0.9em;
  text-align: center;
}

.blog-title {
  font-size: 1.3em;
  margin: 0;
  color: #2c3e50;
  font-weight: 600;
  flex: 1;
  line-height: 1.4;
}

.blog-author {
  font-size: 1em;
  color: #2c3e50;
  margin: 0;
  flex: 1;
  line-height: 1.8;
}

.blog-description {
  font-size: 1em;
  color: #2c3e50;
  margin: 0;
  flex: 1;
  line-height: 1.6;
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

.auth-button {
  background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
  color: white;
}

.auth-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  background: linear-gradient(135deg, #27ae60 0%, #219a52 100%);
}
.like-button {
  margin-left: auto; /* Push to the right side */
  padding: 8px;
  background: none;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: transform 0.3s ease, opacity 0.3s ease;
}

.like-button:hover {
  transform: scale(1.1);
  opacity: 0.8;
}

.like-icon {
  width: 70px; 
  height: 70px;
  object-fit: contain;
}


@media (max-width: 768px) {
  .blog-container {
    grid-template-columns: 1fr;
    padding: 15px;
  }

  .content-row {
    flex-direction: column;
    gap: 8px;
  }

  .label {
    min-width: auto;
    align-self: flex-start;
  }
}
</style>