import defaultTheme from 'tailwindcss/defaultTheme';
import forms from '@tailwindcss/forms';

/** @type {import('tailwindcss').Config} */
export default {
    darkMode: 'class',

    content: [
        './vendor/laravel/framework/src/Illuminate/Pagination/resources/views/*.blade.php',
        './storage/framework/views/*.php',
        './resources/views/**/*.blade.php',
    ],

    theme: {
        extend: {
            fontFamily: {
                sans: ['Inter', 'Figtree', ...defaultTheme.fontFamily.sans],
            },
            colors: {
                gaming: {
                    50: '#eef2ff',
                    100: '#e0e7ff',
                    200: '#c7d2fe',
                    300: '#a5b4fc',
                    400: '#818cf8',
                    500: '#6366f1',
                    600: '#4f46e5',
                    700: '#4338ca',
                    800: '#3730a3',
                    900: '#312e81',
                    950: '#1e1b4b',
                },
                neon: {
                    blue: '#00d4ff',
                    purple: '#a855f7',
                    pink: '#ec4899',
                    cyan: '#06b6d4',
                    green: '#10b981',
                },
                dark: {
                    900: '#0a0a1a',
                    800: '#0f0f2e',
                    700: '#161640',
                    600: '#1e1e52',
                    500: '#252564',
                },
            },
            boxShadow: {
                'neon-blue': '0 0 15px rgba(0, 212, 255, 0.4), 0 0 45px rgba(0, 212, 255, 0.15)',
                'neon-purple': '0 0 15px rgba(168, 85, 247, 0.4), 0 0 45px rgba(168, 85, 247, 0.15)',
                'neon-pink': '0 0 15px rgba(236, 72, 153, 0.4), 0 0 45px rgba(236, 72, 153, 0.15)',
                'card-glow': '0 0 20px rgba(99, 102, 241, 0.15), 0 4px 20px rgba(0, 0, 0, 0.3)',
            },
            animation: {
                'float': 'float 6s ease-in-out infinite',
                'pulse-slow': 'pulse 3s ease-in-out infinite',
                'glow': 'glow 2s ease-in-out infinite alternate',
                'slide-up': 'slideUp 0.6s ease-out',
                'slide-in-left': 'slideInLeft 0.6s ease-out',
                'slide-in-right': 'slideInRight 0.6s ease-out',
                'fade-in': 'fadeIn 0.8s ease-out',
                'bounce-gentle': 'bounceGentle 2s ease-in-out infinite',
            },
            keyframes: {
                float: {
                    '0%, 100%': { transform: 'translateY(0px)' },
                    '50%': { transform: 'translateY(-20px)' },
                },
                glow: {
                    '0%': { boxShadow: '0 0 10px rgba(0, 212, 255, 0.3)' },
                    '100%': { boxShadow: '0 0 25px rgba(0, 212, 255, 0.6), 0 0 50px rgba(0, 212, 255, 0.2)' },
                },
                slideUp: {
                    '0%': { transform: 'translateY(30px)', opacity: '0' },
                    '100%': { transform: 'translateY(0)', opacity: '1' },
                },
                slideInLeft: {
                    '0%': { transform: 'translateX(-30px)', opacity: '0' },
                    '100%': { transform: 'translateX(0)', opacity: '1' },
                },
                slideInRight: {
                    '0%': { transform: 'translateX(30px)', opacity: '0' },
                    '100%': { transform: 'translateX(0)', opacity: '1' },
                },
                fadeIn: {
                    '0%': { opacity: '0' },
                    '100%': { opacity: '1' },
                },
                bounceGentle: {
                    '0%, 100%': { transform: 'translateY(0)' },
                    '50%': { transform: 'translateY(-8px)' },
                },
            },
            backgroundImage: {
                'gradient-gaming': 'linear-gradient(135deg, #0a0a1a 0%, #1e1b4b 50%, #0f0f2e 100%)',
                'gradient-card': 'linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(168, 85, 247, 0.1) 100%)',
                'gradient-neon': 'linear-gradient(135deg, #00d4ff 0%, #a855f7 50%, #ec4899 100%)',
            },
        },
    },

    plugins: [forms],
};
