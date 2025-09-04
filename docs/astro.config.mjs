import starlight from '@astrojs/starlight';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'astro/config';
import starlightLinksValidator from 'starlight-links-validator';

// https://astro.build/config
export default defineConfig({
  site: 'https://docs.blocsync.dev',
  integrations: [
    starlight({
      title: 'Blocsync Docs',
      description: 'A bloc that syncs its state to the cloud.',
      logo: {
        src: './src/assets/logo.svg',
        alt: 'Blocsync logo',
      },
      social: [
        {
          icon: 'github',
          link: 'https://github.com/mtwichel/blocsync',
          ariaLabel: 'GitHub',
          label: 'GitHub',
          href: 'https://github.com/mtwichel/blocsync',
        },
      ],
      customCss: ['./src/tailwind.css'],
      sidebar: [
        {
          label: '🚀 Quick Start',
          link: '/',
        },
        {
          label: 'Basics',
          items: [
            { label: '🔄 SyncedBloc', link: '/basics/synced-bloc/' },
            {
              label: '📦 Partitioned Blocs',
              link: '/basics/partitioned-blocs/',
            },
            { label: '🤫 Private Blocs', link: '/basics/private-blocs/' },
          ],
        },
        {
          label: 'Authentication',
          items: [
            { label: 'Firebase Auth', link: '/authentication/firebase-auth/' },
            {
              label: 'Supabase Provider',
              link: '/authentication/supabase-auth/',
            },
            {
              label: 'Super Simple Authentication',
              link: '/authentication/super-simple-authentication/',
            },
            {
              label: 'Custom Auth Provider',
              link: '/authentication/custom-provider/',
            },
          ],
        },
        {
          label: '🗺️ Roadmap',
          link: '/roadmap/',
        },
      ],
      head: [
        {
          tag: 'link',
          attrs: {
            rel: 'icon',
            type: 'image/x-icon',
            href: '/favicon.ico',
          },
        },
        {
          tag: 'link',
          attrs: {
            rel: 'icon',
            type: 'image/svg+xml',
            href: '/logo.svg',
          },
        },
        {
          tag: 'link',
          attrs: {
            rel: 'apple-touch-icon',
            sizes: '180x180',
            href: '/favicon.ico',
          },
        },
        {
          tag: 'meta',
          attrs: {
            name: 'theme-color',
            content: '#007880',
          },
        },
        {
          tag: 'meta',
          attrs: {
            name: 'msapplication-TileColor',
            content: '#007880',
          },
        },
      ],
      plugins: [
        starlightLinksValidator({
          errorOnFallbackPages: false,
          errorOnInconsistentLocale: true,
          exclude: ['/blog/**', 'http://localhost:8080', 'http://localhost:8080/**'],
        }),
      ],
    }),
  ],
  vite: { plugins: [tailwindcss()] },
});
