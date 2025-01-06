<template>
    <div class="container">
        <h1>{{ isEdit ? 'Edit Blog Post' : 'New Blog Post' }}</h1>
        <div v-if="errors.length">
            <h3 class="text-danger">
                {{ errors.join(', ') }}
            </h3>
        </div>
        <form @submit.prevent="submitForm">
            <div>
                <label for="title">Title</label>
                <input type="text" v-model="title" required />
            </div><br>
            <div>
                <label for="description">Description</label>
                <textarea v-model="description" required></textarea>
            </div><br>
            <div v-if="isEdit">
                <p><strong>Current Image:</strong></p>
                <img :src="currentImageUrl" alt="Current Image" class="img-thumbnail" style="max-width: 300px;" />
            </div><br>
            <div >
                <label for="image">Upload Image (JPEG, 2MB-8MB)</label>
                <input type="file" @change="handleFileUpload" accept="image/jpeg" class="form-control" />
            </div><br>
            <div>
                <button type="submit">{{ isEdit ? 'Update Blog Post' : 'Create Blog Post' }}</button>
            </div><br>
            <router-link to="/" class="btn">Back to Blog Posts</router-link>
        </form>
    </div>
</template>

<script>
import axios from 'axios';
import { mapGetters } from 'vuex';

export default {
    data() {
        return {
            title: '',
            description: '',
            image: null,
            errors: [],
            isEdit: false,
            currentImageUrl: '', 
        };
    },
    computed: {
        ...mapGetters('auth', ['getUser']),
        userToken() {
            return this.getUser.user_token;
        },
    },
    async created() {
        const postId = this.$route.params.id;
        if (postId) {
            this.isEdit = true;
            await this.getBlogPost(postId);
        }
    },
    methods: {
        handleFileUpload(event) {
            this.image = event.target.files[0];
        },
        async getBlogPost(id) {
            try {
                const response = await axios.get(`http://127.0.0.1:3000/api/v1/blog_posts/${id}`, {
                    headers: {
                        'Authorization': `Bearer ${this.userToken}`
                    }
                });
                const current_user =response.data.current_user;
                if (current_user.id === response.data.user.id)
                {
                    const post = response.data.post;
                    this.title = post.title;
                    this.description = post.description;
                    this.currentImageUrl = post.image_url;
                }
                else{
                    this.$router.push('/');
                }
            } catch (error) {
                this.errors.push('Failed to fetch the blog post.');
            }
        },
        async submitForm() {
            this.errors = [];
            if (!this.isEdit && (!this.image || this.image.size < 2 * 1024 * 1024 || this.image.size > 8 * 1024 * 1024)) {
                this.errors.push('Image must be a JPEG and between 2MB and 8MB.');
                return;
            }

            const formData = new FormData();
            formData.append('blog_post[title]', this.title);
            formData.append('blog_post[description]', this.description);
            if (this.image) {
                formData.append('blog_post[image]', this.image);
            }

            try {
                const url = this.isEdit
                    ? `http://127.0.0.1:3000/api/v1/blog_posts/${this.$route.params.id}`
                    : 'http://127.0.0.1:3000/api/v1/blog_posts';

                const method = this.isEdit ? 'put' : 'post';

                const response = await axios({
                    method,
                    url,
                    data: formData,
                    headers: {
                        'Content-Type': 'multipart/form-data',
                        'Authorization': `Bearer ${this.userToken}`
                    }
                });

                console.log(`${this.isEdit ? 'Updated' : 'Created'} blog post:`, response);
                this.$router.push('/blog-posts');
            } catch (error) {
                this.errors.push(`Failed to ${this.isEdit ? 'update' : 'create'} blog post.`);
            }
        },
    }
};
</script>


<style scoped>
.container {
    background-color:#c2ecd9;
    padding: 2rem;
    border-radius: 20px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    width: 300px;
    margin: 0 auto;
}

h1 {
    text-align: center;
    color: #333;
    margin-bottom: 1.5rem;
}

input, textarea {
    width: 100%;
    padding: 0.5rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
}

label {
    display: block;
    margin-bottom: 0.5rem;
    color: #000000;
    font-size: 1.2rem;
}

button, .btn {
    width: 100%;
    padding: 0.75rem;
    background-color: #1877f2;
    color: #fff;
    border: none;
    border-radius: 4px;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.3s ease;
}
.btn{
    text-decoration: none;
}

button:hover, .btn:hover {
    background-color: #00935b;
}

.text-danger {
    color: red;
    font-size: 18px;
    font-weight: bold;
    margin-bottom: 15px;
}
</style>