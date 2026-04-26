<x-app-layout>
@php
    $priceP1 = App\Models\Setting::getVal('price_gm_epic', 60000);
    $priceP2 = App\Models\Setting::getVal('price_epic_legend', 100000);
    $priceP3 = App\Models\Setting::getVal('price_legend_mythic', 150000);

    $starGm = App\Models\Setting::getVal('star_grandmaster', 3000);
    $starEpic = App\Models\Setting::getVal('star_epic', 4000);
    $starLegend = App\Models\Setting::getVal('star_legend', 6000);
    $starMythic = App\Models\Setting::getVal('star_mythic', 9000);
    $starHonor = App\Models\Setting::getVal('star_honor', 13000);
    $starGlory = App\Models\Setting::getVal('star_glory', 30000);
    $starImmortal = App\Models\Setting::getVal('star_immortal', 100000);
@endphp

    {{-- ============ HERO SECTION ============ --}}
    <section id="hero" class="relative min-h-screen flex items-center overflow-hidden">
        {{-- Background Effects --}}
        <div class="bg-orb bg-orb-blue w-96 h-96 -top-48 -left-48"></div>
        <div class="bg-orb bg-orb-purple w-80 h-80 top-1/3 right-0"></div>
        <div class="bg-orb bg-orb-pink w-64 h-64 bottom-0 left-1/3"></div>

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 w-full">
            <div class="flex flex-col lg:flex-row items-center justify-between gap-12">
                {{-- Left Content --}}
                <div class="flex-1 text-center lg:text-left animate-slide-up">
                    <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-gaming-500/10 border border-gaming-500/30 text-gaming-300 text-sm font-medium mb-6">
                        <span class="w-2 h-2 rounded-full bg-green-400 animate-pulse"></span>
                        #1 Jasa Joki Terpercaya di Indonesia
                    </div>

                    <h1 class="text-4xl sm:text-5xl lg:text-6xl font-black leading-tight mb-6">
                        <span class="text-white">Joki Mobile Legends</span><br>
                        <span class="text-neon">Profesional</span>
                    </h1>

                    <p class="text-lg text-gray-400 mb-8 max-w-xl mx-auto lg:mx-0">
                        Naik rank lebih cepat, aman, dan terpercaya. Dipercaya oleh ribuan player di seluruh Indonesia.
                    </p>

                    <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start mb-10">
                        <a href="#paket" class="btn-neon text-center">
                            🚀 Lihat Paket Joki
                        </a>
                        <a href="https://wa.me/6285198181867" target="_blank"
                           class="px-8 py-3 rounded-xl font-semibold text-white border border-white/20 hover:border-green-500/50 hover:bg-green-500/10 transition-all duration-300 text-center">
                            💬 Hubungi Kami
                        </a>
                    </div>

                    {{-- Badges --}}
                    <div class="flex flex-wrap gap-3 justify-center lg:justify-start">
                        <span class="badge-feature">✔️ Aman 100%</span>
                        <span class="badge-feature">⚡ Proses Cepat</span>
                        <span class="badge-feature">💰 Harga Terjangkau</span>
                    </div>
                </div>

                {{-- Right Image --}}
                <div class="flex-1 flex justify-center animate-slide-in-right">
                    <div class="relative">
                        <div class="absolute inset-0 bg-gradient-to-br from-gaming-500/20 to-neon-purple/20 rounded-3xl blur-3xl"></div>
                        <img src="{{ asset('img/rank.png') }}" alt="Mobile Legends Rank" class="relative w-72 sm:w-80 lg:w-96 animate-float drop-shadow-2xl">
                    </div>
                </div>
            </div>
        </div>
    </section>

    {{-- ============ PAKET JOKI SECTION ============ --}}
    <section id="paket" class="relative py-20">
        <div class="bg-orb bg-orb-purple w-72 h-72 top-0 right-0"></div>
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="divider-neon"></div>
            <h2 class="section-title text-white">Paket <span class="text-neon">Joki Rank</span></h2>
            <p class="section-subtitle">Pilih paket yang sesuai dengan kebutuhan rank kamu</p>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                @php
                $pakets = [
                    ['from'=>'Grandmaster','to'=>'Epic','price'=>'Rp '.number_format($priceP1, 0, ',', '.'),'raw_price'=>$priceP1,'desc'=>'Masuk ke ranked Epic dengan bantuan pro player','color'=>'from-purple-500 to-pink-400','icon'=>'💎'],
                    ['from'=>'Epic','to'=>'Legend','price'=>'Rp '.number_format($priceP2, 0, ',', '.'),'raw_price'=>$priceP2,'desc'=>'Tingkatkan skill dan rank ke level Legend','color'=>'from-orange-500 to-red-400','icon'=>'🔥'],
                    ['from'=>'Legend','to'=>'Mythic','price'=>'Rp '.number_format($priceP3, 0, ',', '.'),'raw_price'=>$priceP3,'desc'=>'Capai rank tertinggi bersama joki profesional','color'=>'from-red-500 to-pink-500','icon'=>'👑','popular'=>true],
                ];
                @endphp

                @foreach($pakets as $i => $p)
                <div class="package-card group" style="animation-delay: {{ $i * 100 }}ms">
                    @if(!empty($p['popular']))
                        <div class="package-badge">🔥 Terpopuler</div>
                    @endif

                    <div class="flex items-center gap-3 mb-4 {{ !empty($p['popular']) ? 'mt-4' : '' }}">
                        <div class="w-12 h-12 rounded-xl bg-gradient-to-br {{ $p['color'] }} flex items-center justify-center text-2xl shadow-lg">
                            {{ $p['icon'] }}
                        </div>
                        <div>
                            <h3 class="font-bold text-white text-lg">{{ $p['from'] }} → {{ $p['to'] }}</h3>
                        </div>
                    </div>

                    <p class="text-gray-400 text-sm mb-4">{{ $p['desc'] }}</p>

                    <div class="flex items-end gap-1 mb-5">
                        <span class="text-3xl font-black text-neon-blue">{{ $p['price'] }}</span>
                    </div>

                    <ul class="space-y-2 mb-6 text-sm text-gray-400">
                        <li class="flex items-center gap-2"><span class="text-green-400">✓</span> Proses 1-3 hari</li>
                        <li class="flex items-center gap-2"><span class="text-green-400">✓</span> Garansi keamanan akun</li>
                        <li class="flex items-center gap-2"><span class="text-green-400">✓</span> Laporan progress harian</li>
                    </ul>

                    <form action="{{ route('order.init') }}" method="POST">
                        @csrf
                        <input type="hidden" name="type" value="paket">
                        <input type="hidden" name="paket_name" value="{{ $p['from'] }} → {{ $p['to'] }}">
                        <input type="hidden" name="price" value="{{ $p['raw_price'] }}">
                        <button type="submit" class="block w-full text-center btn-neon !rounded-xl text-sm border-0 cursor-pointer">
                            Pesan Sekarang
                        </button>
                    </form>
                </div>
                @endforeach
            </div>
        </div>
    </section>

    {{-- ============ KALKULATOR JOKI SECTION ============ --}}
    <section id="kalkulator" class="relative py-20" x-data="kalkulatorJoki()">
        <div class="bg-orb bg-orb-purple w-80 h-80 top-0 left-0"></div>
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="divider-neon"></div>
            <h2 class="section-title text-white">Kalkulator <span class="text-neon">Joki Custom</span></h2>
            <p class="section-subtitle">Hitung sendiri biaya joki sesuai rank dan bintang kamu</p>

            <div class="glass-card p-8">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    {{-- Rank Asal --}}
                    <div>
                        <label class="block text-sm font-semibold text-gaming-300 mb-2">📍 Rank Saat Ini</label>
                        <select x-model="fromRank" @change="calculate()" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500 transition-all">
                            <option value="">-- Pilih Rank --</option>
                            <template x-for="r in ranks" :key="r.id">
                                <option :value="r.id" x-text="r.name"></option>
                            </template>
                        </select>

                        <label class="block text-sm font-semibold text-gaming-300 mb-2">⭐ Bintang Saat Ini</label>
                        <template x-if="!isFreeInput(fromRank)">
                            <select x-model="fromStar" @change="calculate()" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500 transition-all">
                                <option value="">-- Pilih Bintang --</option>
                                <template x-for="s in getStarOptions(fromRank)" :key="s">
                                    <option :value="s" x-text="s + ' ⭐'"></option>
                                </template>
                            </select>
                        </template>
                        <template x-if="isFreeInput(fromRank)">
                            <input type="number" x-model="fromStar" @input="calculate()" min="0" placeholder="Masukkan jumlah bintang" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500 transition-all">
                        </template>
                    </div>

                    {{-- Rank Tujuan --}}
                    <div>
                        <label class="block text-sm font-semibold text-gaming-300 mb-2">🎯 Rank Tujuan</label>
                        <select x-model="toRank" @change="calculate()" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500 transition-all">
                            <option value="">-- Pilih Rank --</option>
                            <template x-for="r in getTargetRanks()" :key="r.id">
                                <option :value="r.id" x-text="r.name"></option>
                            </template>
                        </select>

                        <label class="block text-sm font-semibold text-gaming-300 mt-4 mb-2">⭐ Bintang Tujuan</label>
                        <template x-if="!isFreeInput(toRank)">
                            <select x-model="toStar" @change="calculate()" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500 transition-all">
                                <option value="">-- Pilih Bintang --</option>
                                <template x-for="s in getStarOptions(toRank)" :key="s">
                                    <option :value="s" x-text="s + ' ⭐'"></option>
                                </template>
                            </select>
                        </template>
                        <template x-if="isFreeInput(toRank)">
                            <input type="number" x-model="toStar" @input="calculate()" min="0" placeholder="Masukkan jumlah bintang" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500 transition-all">
                        </template>
                    </div>
                </div>

                {{-- Hasil --}}
                <div x-show="totalCost > 0" x-transition class="mt-8 p-6 rounded-2xl bg-gradient-to-br from-gaming-500/10 to-neon-purple/10 border border-gaming-500/30 text-center">
                    <p class="text-gray-400 text-sm mb-2">Total Biaya Joki</p>
                    <p class="text-4xl font-black text-neon mb-2" x-text="'Rp ' + totalCost.toLocaleString('id-ID')"></p>
                    <p class="text-gray-400 text-sm mb-1" x-text="'Total ' + totalStars + ' bintang'"></p>
                    <p class="text-gray-500 text-xs mb-6" x-text="detail"></p>
                    <form action="{{ route('order.init') }}" method="POST" class="inline-block mt-2">
                        @csrf
                        <input type="hidden" name="type" value="custom">
                        <input type="hidden" name="from_rank" :value="getFromName()">
                        <input type="hidden" name="to_rank" :value="getToName()">
                        <input type="hidden" name="from_star" :value="fromStar">
                        <input type="hidden" name="to_star" :value="toStar">
                        <input type="hidden" name="price" :value="totalCost">
                        <button type="submit" class="btn-neon text-sm border-0 cursor-pointer">
                            💳 Pesan & Bayar
                        </button>
                    </form>
                </div>

                <div x-show="errorMsg" x-transition class="mt-6 p-4 rounded-xl bg-red-500/10 border border-red-500/30 text-red-400 text-sm text-center" x-text="errorMsg"></div>

                {{-- Price Table --}}
                <div class="mt-8 overflow-x-auto">
                    <p class="text-sm font-semibold text-gaming-300 mb-3">📋 Daftar Harga per Bintang:</p>
                    <table class="w-full text-sm text-left">
                        <thead>
                            <tr class="border-b border-white/10">
                                <th class="py-2 px-3 text-gaming-400 font-medium">Tier</th>
                                <th class="py-2 px-3 text-gaming-400 font-medium text-right">Harga/Bintang</th>
                            </tr>
                        </thead>
                        <tbody class="text-gray-400">
                            <tr class="border-b border-white/5"><td class="py-2 px-3">Epic → Legend</td><td class="py-2 px-3 text-right text-neon-blue font-semibold">Rp {{ number_format($starEpic, 0, ',', '.') }}</td></tr>
                            <tr class="border-b border-white/5"><td class="py-2 px-3">Legend → Mythic</td><td class="py-2 px-3 text-right text-neon-blue font-semibold">Rp {{ number_format($starLegend, 0, ',', '.') }}</td></tr>
                            <tr class="border-b border-white/5"><td class="py-2 px-3">Mythic → Mythic Honor</td><td class="py-2 px-3 text-right text-neon-blue font-semibold">Rp {{ number_format($starMythic, 0, ',', '.') }}</td></tr>
                            <tr class="border-b border-white/5"><td class="py-2 px-3">Mythic Honor → Mythical Glory</td><td class="py-2 px-3 text-right text-neon-blue font-semibold">Rp {{ number_format($starHonor, 0, ',', '.') }}</td></tr>
                            <tr class="border-b border-white/5"><td class="py-2 px-3">Mythical Glory → Immortal</td><td class="py-2 px-3 text-right text-neon-blue font-semibold">Rp {{ number_format($starGlory, 0, ',', '.') }}</td></tr>
                            <tr><td class="py-2 px-3">Immortal → Immortal</td><td class="py-2 px-3 text-right text-neon-blue font-semibold">Rp {{ number_format($starImmortal, 0, ',', '.') }}</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
        function kalkulatorJoki() {
            return {
                fromRank: '', fromStar: '', toRank: '', toStar: '',
                totalCost: 0, totalStars: 0, detail: '', errorMsg: '',
                ranks: [
                    { id: 'epic5', name: 'Epic V', tier: 'epic', order: 1, maxStar: 5 },
                    { id: 'epic4', name: 'Epic IV', tier: 'epic', order: 2, maxStar: 5 },
                    { id: 'epic3', name: 'Epic III', tier: 'epic', order: 3, maxStar: 5 },
                    { id: 'epic2', name: 'Epic II', tier: 'epic', order: 4, maxStar: 5 },
                    { id: 'epic1', name: 'Epic I', tier: 'epic', order: 5, maxStar: 5 },
                    { id: 'legend5', name: 'Legend V', tier: 'legend', order: 6, maxStar: 5 },
                    { id: 'legend4', name: 'Legend IV', tier: 'legend', order: 7, maxStar: 5 },
                    { id: 'legend3', name: 'Legend III', tier: 'legend', order: 8, maxStar: 5 },
                    { id: 'legend2', name: 'Legend II', tier: 'legend', order: 9, maxStar: 5 },
                    { id: 'legend1', name: 'Legend I', tier: 'legend', order: 10, maxStar: 5 },
                    { id: 'mythic', name: 'Mythic', tier: 'mythic', order: 11, maxStar: 5, freeInput: true },
                    { id: 'mythic_honor', name: 'Mythic Honor', tier: 'mythic_honor', order: 12, maxStar: 5, freeInput: true },
                    { id: 'mythical_glory', name: 'Mythical Glory', tier: 'mythical_glory', order: 13, maxStar: 5, freeInput: true },
                    { id: 'immortal', name: 'Immortal', tier: 'immortal', order: 14, maxStar: 5, freeInput: true },
                ],
                tierPrice: { epic: {{ $starEpic }}, legend: {{ $starLegend }}, mythic: {{ $starMythic }}, mythic_honor: {{ $starHonor }}, mythical_glory: {{ $starGlory }}, immortal: {{ $starImmortal }} },

                isFreeInput(rankId) {
                    let r = this.getRank(rankId);
                    return r ? !!r.freeInput : false;
                },

                getRank(id) { return this.ranks.find(r => r.id === id); },
                getFromName() { let r = this.getRank(this.fromRank); return r ? r.name : ''; },
                getToName() { let r = this.getRank(this.toRank); return r ? r.name : ''; },

                getStarOptions(rankId) {
                    let r = this.getRank(rankId);
                    if (!r) return [];
                    let opts = [];
                    for (let i = 0; i <= r.maxStar; i++) opts.push(i);
                    return opts;
                },

                getTargetRanks() {
                    if (!this.fromRank) return this.ranks;
                    let from = this.getRank(this.fromRank);
                    if (!from) return this.ranks;
                    return this.ranks.filter(r => r.order >= from.order);
                },

                calculate() {
                    this.totalCost = 0; this.totalStars = 0; this.detail = ''; this.errorMsg = '';
                    if (!this.fromRank || this.fromStar === '' || !this.toRank || this.toStar === '') return;

                    let from = this.getRank(this.fromRank);
                    let to = this.getRank(this.toRank);
                    if (!from || !to) return;

                    if (to.order < from.order) {
                        this.errorMsg = 'Rank tujuan harus lebih tinggi atau sama dengan rank saat ini!';
                        return;
                    }
                    if (to.order === from.order && parseInt(this.toStar) <= parseInt(this.fromStar)) {
                        this.errorMsg = 'Bintang tujuan harus lebih tinggi!';
                        return;
                    }

                    let cost = 0, stars = 0, details = [];
                    let fromIdx = this.ranks.findIndex(r => r.id === this.fromRank);
                    let toIdx = this.ranks.findIndex(r => r.id === this.toRank);
                    let fStar = parseInt(this.fromStar);
                    let tStar = parseInt(this.toStar);

                    if (fromIdx === toIdx) {
                        let diff = tStar - fStar;
                        let price = this.tierPrice[from.tier];
                        if (price && diff > 0) {
                            cost = diff * price;
                            stars = diff;
                            details.push(from.name + ': ' + diff + '⭐ × Rp ' + price.toLocaleString('id-ID'));
                        }
                    } else {
                        for (let i = fromIdx; i < toIdx; i++) {
                            let rank = this.ranks[i];
                            let price = this.tierPrice[rank.tier];
                            if (!price) continue;
                            let s = (i === fromIdx) ? (rank.maxStar - fStar) : rank.maxStar;
                            if (s > 0) {
                                cost += s * price;
                                stars += s;
                                details.push(rank.name + ': ' + s + '⭐ × Rp ' + price.toLocaleString('id-ID'));
                            }
                        }
                        
                        if (tStar > 0) {
                            let toRankData = this.ranks[toIdx];
                            let prevTier = toIdx > 0 ? this.ranks[toIdx - 1].tier : toRankData.tier;
                            let price = this.tierPrice[prevTier] || this.tierPrice[toRankData.tier];
                            if (price) {
                                cost += tStar * price;
                                stars += tStar;
                                details.push(toRankData.name + ': ' + tStar + '⭐ × Rp ' + price.toLocaleString('id-ID'));
                            }
                        }
                    }

                    this.totalCost = cost;
                    this.totalStars = stars;
                    this.detail = details.join(' | ');
                }
            }
        }
        </script>
    </section>

    {{-- ============ KEUNGGULAN SECTION ============ --}}
    <section id="keunggulan" class="relative py-20">
        <div class="bg-orb bg-orb-blue w-80 h-80 bottom-0 left-0"></div>
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="divider-neon"></div>
            <h2 class="section-title text-white">Kenapa Pilih <span class="text-neon">Kami?</span></h2>
            <p class="section-subtitle">Kami memberikan pelayanan terbaik untuk setiap customer</p>

            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                @php
                $features = [
                    ['icon'=>'<svg class="w-8 h-8" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>','title'=>'Joki Profesional','desc'=>'Tim joki berpengalaman dengan winrate tinggi di semua tier rank'],
                    ['icon'=>'<svg class="w-8 h-8" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>','title'=>'Proses Cepat','desc'=>'Estimasi pengerjaan 1-3 hari kerja sesuai paket yang dipilih'],
                    ['icon'=>'<svg class="w-8 h-8" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>','title'=>'Aman Tanpa Ban','desc'=>'Menggunakan teknik anti-detect sehingga akun tetap aman 100%'],
                    ['icon'=>'<svg class="w-8 h-8" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M18.364 5.636l-3.536 3.536m0 5.656l3.536 3.536M9.172 9.172L5.636 5.636m3.536 9.192l-3.536 3.536M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-5 0a4 4 0 11-8 0 4 4 0 018 0z"/></svg>','title'=>'Support 24 Jam','desc'=>'Customer service siap membantu kapan saja via WhatsApp'],
                ];
                @endphp

                @foreach($features as $i => $f)
                <div class="gaming-card text-center group">
                    <div class="w-16 h-16 rounded-2xl bg-gradient-to-br from-gaming-500/20 to-neon-purple/20 border border-gaming-500/30 flex items-center justify-center mx-auto mb-4 text-gaming-400 group-hover:text-neon-blue group-hover:border-neon-blue/30 group-hover:shadow-neon-blue transition-all duration-500">
                        {!! $f['icon'] !!}
                    </div>
                    <h3 class="text-lg font-bold text-white mb-2">{{ $f['title'] }}</h3>
                    <p class="text-gray-400 text-sm">{{ $f['desc'] }}</p>
                </div>
                @endforeach
            </div>
        </div>
    </section>

    {{-- ============ TESTIMONI SECTION ============ --}}
    <section id="testimoni" class="relative py-20">
        <div class="bg-orb bg-orb-pink w-72 h-72 top-1/2 right-0"></div>
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="divider-neon"></div>
            <h2 class="section-title text-white">Apa Kata <span class="text-neon">Mereka?</span></h2>
            <p class="section-subtitle">Testimoni dari pelanggan yang sudah menggunakan jasa kami</p>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                @forelse($testimonials as $t)
                <div class="gaming-card relative">
                    <div class="flex items-center gap-4 mb-4">
                        <div class="w-12 h-12 rounded-full bg-gradient-to-br from-gaming-500 to-neon-purple flex items-center justify-center text-white font-bold text-lg">
                            {{ strtoupper(substr($t->user->name ?? 'U', 0, 2)) }}
                        </div>
                        <div>
                            <h4 class="font-semibold text-white">{{ $t->user->name ?? 'User' }}</h4>
                            <div class="text-yellow-400 text-xs">
                                @for($i=0; $i<$t->rating; $i++) ⭐ @endfor
                            </div>
                        </div>
                    </div>
                    <p class="text-gray-400 text-sm mb-3 italic">"{{ $t->content }}"</p>
                    
                    @if($t->reply)
                        <div class="mt-4 p-3 bg-dark-800/80 rounded-xl border border-gaming-500/30">
                            <p class="text-xs font-bold text-neon-blue mb-1">Admin Reply:</p>
                            <p class="text-gray-300 text-xs">{{ $t->reply }}</p>
                        </div>
                    @endif
                </div>
                @empty
                    <div class="col-span-3 text-center text-gray-500 py-4">Belum ada testimoni.</div>
                @endforelse
            </div>
        </div>
    </section>

    {{-- ============ FAQ SECTION ============ --}}
    <section id="faq" class="relative py-20" x-data="{ openFaq: null }">
        <div class="bg-orb bg-orb-blue w-64 h-64 bottom-0 right-1/4"></div>
        <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="divider-neon"></div>
            <h2 class="section-title text-white">Pertanyaan <span class="text-neon">Umum</span></h2>
            <p class="section-subtitle">Temukan jawaban untuk pertanyaan yang sering ditanyakan</p>

            @php
            $faqs = [
                ['q'=>'Apakah akun saya aman?','a'=>'Ya, 100% aman! Kami menggunakan VPN dan teknik anti-detect sehingga akun Anda tidak akan terkena ban. Kami juga memberikan garansi keamanan akun.'],
                ['q'=>'Berapa lama proses joki?','a'=>'Tergantung paket yang dipilih. Rata-rata 1-3 hari kerja. Untuk paket Legend ke Mythic bisa memakan waktu 3-5 hari kerja.'],
                ['q'=>'Apakah bisa request hero tertentu?','a'=>'Tentu! Anda bisa request hero favorit yang akan digunakan selama proses joki. Joki kami menguasai semua hero dan role.'],
                ['q'=>'Bagaimana cara pembayaran?','a'=>'Kami menerima pembayaran via transfer bank (BCA, BNI, Mandiri), e-wallet (DANA, OVO, GoPay), dan pulsa.'],
                ['q'=>'Apakah ada garansi?','a'=>'Ya! Jika rank turun selama proses joki, kami akan menaikkan kembali secara gratis. Kepuasan pelanggan adalah prioritas kami.'],
            ];
            @endphp

            <div class="space-y-3">
                @foreach($faqs as $i => $faq)
                <div class="accordion-item">
                    <button @click="openFaq = openFaq === {{ $i }} ? null : {{ $i }}" class="accordion-header">
                        <span>{{ $faq['q'] }}</span>
                        <svg :class="{ 'rotate-180': openFaq === {{ $i }} }" class="w-5 h-5 transition-transform duration-300 text-gaming-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7"/>
                        </svg>
                    </button>
                    <div x-show="openFaq === {{ $i }}" x-transition:enter="transition ease-out duration-200" x-transition:enter-start="opacity-0 transform -translate-y-2" x-transition:enter-end="opacity-100 transform translate-y-0" x-transition:leave="transition ease-in duration-150" x-transition:leave-start="opacity-100" x-transition:leave-end="opacity-0" class="px-5 pb-5 text-gray-400 text-sm leading-relaxed">
                        {{ $faq['a'] }}
                    </div>
                </div>
                @endforeach
            </div>
        </div>
    </section>

    {{-- ============ FOOTER ============ --}}
    <footer class="relative border-t border-white/5 pt-16 pb-8">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-12 mb-12">
                {{-- Logo & Info --}}
                <div>
                    <div class="flex items-center gap-3 mb-4">
                        <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-gaming-500 to-neon-purple flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 24 24"><path d="M21 6H3a1 1 0 00-1 1v10a1 1 0 001 1h18a1 1 0 001-1V7a1 1 0 00-1-1zM8 15a2 2 0 110-4 2 2 0 010 4zm4-2a1 1 0 110-2 1 1 0 010 2zm4 2a2 2 0 110-4 2 2 0 010 4z"/></svg>
                        </div>
                        <span class="text-xl font-bold text-neon">JokiML</span>
                    </div>
                    <p class="text-gray-400 text-sm leading-relaxed">Jasa joki Mobile Legends profesional, aman, dan terpercaya. Melayani ribuan customer sejak 2026.</p>
                </div>

                {{-- Links --}}
                <div>
                    <h4 class="font-semibold text-white mb-4">Menu</h4>
                    <ul class="space-y-2 text-sm text-gray-400">
                        <li><a href="#hero" class="hover:text-neon-blue transition-colors">Home</a></li>
                        <li><a href="#paket" class="hover:text-neon-blue transition-colors">Paket Joki</a></li>
                        <li><a href="#testimoni" class="hover:text-neon-blue transition-colors">Testimoni</a></li>
                        <li><a href="#faq" class="hover:text-neon-blue transition-colors">FAQ</a></li>
                    </ul>
                </div>

                {{-- Contact --}}
                <div>
                    <h4 class="font-semibold text-white mb-4">Kontak</h4>
                    <ul class="space-y-3 text-sm text-gray-400">
                        <li class="flex items-center gap-2">
                            <span class="text-green-400">💬</span>
                            <a href="https://wa.me/6285198181867" class="hover:text-neon-blue transition-colors">0851-9818-1867</a>
                        </li>
                        <li class="flex items-center gap-2">
                            <span>📧</span>
                            <a href="mailto:info@jokiml.com" class="hover:text-neon-blue transition-colors">info@jokiml.com</a>
                        </li>
                        <li class="flex items-center gap-2">
                            <span>📸</span>
                            <a href="#" class="hover:text-neon-blue transition-colors">@jokiml_official</a>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="border-t border-white/5 pt-8 text-center text-sm text-gray-500">
                &copy; {{ date('Y') }} JokiML. All rights reserved.
            </div>
        </div>
    </footer>
</x-app-layout>