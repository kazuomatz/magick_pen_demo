<template>

  <div class="main-content">
    <!-- Begin About Me Section -->
    <div class="section-light about-me" id="about-me">
      <div class="container">
        <div class="column is-12 about-me">
          <h1 class="title has-text-centered section-title">About Magick Pen</h1>
        </div>
        <div class="columns is-multiline">
          <div
            class="column is-6 has-vertically-aligned-content"
            data-aos="fade-right"
          >
            <p class="is-larger">
              &emsp;&emsp;
              <strong>
                <vue-magick-pen pen-key="about">
                  Magick Penは、Ruby on Railsで制作されたWebサイト内のページの任意の箇所をダイレクトに編集して更新することを可能にするコンポーネントフレームワークです。
                </vue-magick-pen>
              </strong>
            </p>
            <br />
            <p>
              編集権限を持ったユーザーがサイトにアクセスした場合のみ編集を可能にすることができます。
            </p>
          </div>
          <div class="column is-6 right-image " data-aos="fade-left">
            <img
              class="is-rounded"
              src="https://picsum.photos/id/7/600/375"
              alt=""
            />
          </div>
        </div>
      </div>
    </div>

    <div class="section-color services" id="services">
      <div class="container">
        <div class="columns is-multiline">
          <div
            class="column is-12 about-me"
            data-aos="fade-in"
            data-aos-easing="linear"
          >
            <h1 class="title has-text-centered section-title">Services</h1>

            <h2 class="subtitle">
              <vue-magick-pen pen-key="service-title">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
                eiusmod tempor incididunt ut labore et dolore magna aliqua
              </vue-magick-pen>
            </h2>
            <br />
          </div>
          <div class="columns is-12">
            <div
              class="column is-4 has-text-centered"
              data-aos="fade-in"
              data-aos-easing="linear"
            >
              <i class="fas fa-meteor fa-3x"></i>
              <hr />
              <vue-magick-pen pen-key="service-1">
              <h2>
                  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed
                  do eiusmod tempor incididunt ut labore et dolore magna aliqua
              </h2>
              </vue-magick-pen>
            </div>
            <div
              class="column is-4 has-text-centered"
              data-aos="fade-in"
              data-aos-easing="linear"
            >
              <i class="fas fa-paint-brush fa-3x"></i>
              <hr />
              <h2>
                <vue-magick-pen pen-key="service-2">
                  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed
                  do eiusmod tempor incididunt ut labore et dolore magna aliqua
                </vue-magick-pen>
              </h2>
            </div>
            <div
              class="column is-4 has-text-centered"
              data-aos="fade-in"
              data-aos-easing="linear"
            >
              <i class="fas fa-rocket fa-3x"></i>
              <hr />
              <h2>
                <vue-magick-pen pen-key="service-3">
                  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed
                  do eiusmod tempor incididunt ut labore et dolore magna aliqua
                </vue-magick-pen>
              </h2>
            </div>
          </div>
          <hr />
          <div class="columns is-12">
            <div
              class="column is-4 has-text-centered"
              data-aos="fade-in"
              data-aos-easing="linear"
            >
              <i class="fas fa-upload fa-3x"></i>
              <hr />
              <vue-magick-pen pen-key="service-4">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed
                do eiusmod tempor incididunt ut labore et dolore magna aliqua
              </vue-magick-pen>
            </div>
            <div
              class="column is-4 has-text-centered"
              data-aos="fade-in"
              data-aos-easing="linear"
            >
              <vue-magick-pen pen-key="icon-5">
                <i class="fas fa-bus fa-3x"></i>
              </vue-magick-pen>
              <hr />
              <h2>
                <vue-magick-pen pen-key="service-5">
                  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed
                  do eiusmod tempor incididunt ut labore et dolore magna aliqua
                </vue-magick-pen>
              </h2>
            </div>
            <div
              class="column is-4 has-text-centered"
              data-aos="fade-in"
              data-aos-easing="linear"
            >
              <vue-magick-pen pen-key="icon-6">
                <i class="fas fa-code fa-3x"></i>
              </vue-magick-pen>
              <hr />
              <vue-magick-pen pen-key="service-6">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed
                do eiusmod tempor incididunt ut labore et dolore magna aliqua
              </vue-magick-pen>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- End Main Content -->

</template>

<script>
export default {
  name: "top"
}
</script>

<style scoped>

</style>
